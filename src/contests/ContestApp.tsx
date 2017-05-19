import * as React from 'react';

import ContestObject from 'contests/ContestObject';
import ProblemObject from 'contests/ProblemObject';
import DataSetObject from 'contests/DataSetObject';
import SubmissionObject from 'contests/SubmissionObject';
import UserScoreObject from 'contests/UserScoreObject';
import TimerObject from 'contests/TimerObject';

import JUDGE_STATUS from 'contests/JUDGE_STATUS';

import Navigation from 'contests/Navigation';
import ContestHome from 'contests/ContestHome';
import Problem from 'contests/Problem';
import Submissions from 'contests/Submissions';
import Ranking from 'contests/Ranking';
import SubmitResults from 'contests/SubmitResults';

export interface ContestAppProps extends React.Props<ContestApp> {
  children: React.ReactElement<any>;
  params: {
    contestId: string;
    problemId: string;
  };
}

export interface ContestAppState {
  initialized: boolean;
  contest?: ContestObject;
  submissions?: [ SubmissionObject ];
  users?: [ UserScoreObject ];
  submitResults: [ number ];
}

export default class ContestApp extends React.Component<ContestAppProps, ContestAppState> {
  private csrfParam: string;
  private csrfToken: string;
  private rankingRequestTimerId: number;

  constructor(props: ContestAppProps) {
    super(props);

    this.csrfParam = document.querySelector('meta[name=csrf-param]').getAttribute('content');
    this.csrfToken = document.querySelector('meta[name=csrf-token]').getAttribute('content');

    this.state = {
      initialized: false,
      submitResults: [] as [ number ]
    };
  }

  public componentWillMount() {
    this.fetchContest();
  }

  public componentWillUnmount() {
    if(this.rankingRequestTimerId) {
      clearInterval(this.rankingRequestTimerId);
    }
  }

  public componentDidMount() {
    this.initTimer();
  }

  public async fetchContest() {
    const responseContest: Response = await fetch(`/api/contests/${this.props.params.contestId}${t('locale')}`, {
      credentials: 'same-origin',
    });

    let contest: ContestObject;
    switch(responseContest.status) {
      case 200:
        const json: any = await responseContest.json();
        contest = {
          id: json.id,
          name: json.name,
          description: json.description,
          joined: json.joined,
          currentUserId: json.current_user_id,
          startAt: new Date(json.start_at),
          endAt: new Date(json.end_at),
          baseline: json.baseline
        };
        if(json.problems) {
          Object.assign(contest, {
            problems: json.problems.map((problem: any, index: number) => ({
              id: problem.id,
              task: String.fromCharCode(index + 65),
              name: problem.name,
              description: problem.description,
              dataSets: problem.data_sets.map((dataSet: any) => ({
                id: dataSet.id,
                label: dataSet.label,
                maxScore: dataSet.max_score,
                correct: dataSet.correct,
                score: dataSet.score,
                answer: ''
              }))
            }))
          });
        }
        break;

      case 404: throw new Error('404 not found');
      default: throw new Error('unexpected http status');
    }

    let submissions: [ SubmissionObject ];
    if(contest.problems) {
      const responseSubmissions: Response = await fetch(`/api/contests/${this.props.params.contestId}/submissions${t('locale')}`, {
        credentials: 'same-origin',
      });

      switch(responseSubmissions.status) {
        case 200:
          const json: any = await responseSubmissions.json();
          submissions = json.map((submission: any) => ({
            id: submission.id,
            problemId: submission.problem_id,
            dataSetId: submission.data_set_id,
            judgeStatus: submission.judge_status,
            score: submission.score || 0,
            createdAt: new Date(submission.created_at)
          }));
          break;

        case 403: throw new Error('403 forbidden');
        case 404: throw new Error('404 not found');
        default: throw new Error('unexpected http status');
      }
    }

    this.setState({
      initialized: true,
      contest,
      submissions,
    });

    if(contest.problems) {
      this.fetchRanking();
    }
  }

  public async join() {
    const formData: FormData = new FormData();
    formData.append(this.csrfParam, this.csrfToken);

    const response: Response = await fetch(`/api/contests/${this.props.params.contestId}/entry`, {
      method: "post",
      credentials: 'same-origin',
      body: formData
    });

    switch(response.status) {
      case 201:
        this.fetchContest();
        break;

      case 403: throw new Error('403 forbidden');
      case 404: throw new Error('404 not found');
      case 409: throw new Error('409 conflict');
      default: throw new Error('unexpected http status');
    }
  }

  public async submit(problemId: number, dataSetId: number) {
    const contest = this.state.contest;
    const problems = contest.problems;
    const problemIndex = problems.findIndex((problem) => problem.id === problemId);
    const problem = problems[ problemIndex ];
    const dataSets = problem.dataSets;
    const dataSetIndex = dataSets.findIndex((dataSet) => dataSet.id === dataSetId);
    const dataSet = dataSets[ dataSetIndex ];

    const formData: FormData = new FormData();
    formData.append(this.csrfParam, this.csrfToken);
    formData.append('data_set_id', dataSetId.toString());
    formData.append('answer', dataSet.answer);

    this.changeAnswerForm(problemId, dataSetId, '');

    const response: Response = await fetch(`/api/contests/${this.props.params.contestId}/submissions`, {
      method: 'post',
      credentials: 'same-origin',
      body: formData
    });

    switch(response.status) {
      case 201:
        const json: any = await response.json();
        const contest: ContestObject = this.state.contest;
        const problems: [ ProblemObject ] = contest.problems;
        const problemIndex: number = problems.findIndex((problem) => problem.id === problemId);
        const problem: ProblemObject = problems[ problemIndex ];
        const dataSets: [ DataSetObject ] = problem.dataSets;
        const dataSetIndex: number = dataSets.findIndex((dataSet) => dataSet.id === dataSetId);
        const dataSet: DataSetObject = dataSets[ dataSetIndex ];

        let state: ContestAppState = Object.assign({}, this.state, {
          submissions: this.state.submissions.concat({
            id: json.id,
            problemId: json.problem_id,
            dataSetId: json.data_set_id,
            judgeStatus: json.judge_status,
            score: json.score || 0,
            createdAt: new Date(json.created_at)
          }),
          submitResults: this.state.submitResults.concat(json.id)
        });
        if(json.judge_status === JUDGE_STATUS.AC) {
          Object.assign(state, {
            contest: Object.assign({}, contest, {
              problems: [
                ...problems.slice(0, problemIndex),
                Object.assign({}, problem, {
                  dataSets: [
                    ...dataSets.slice(0, dataSetIndex),
                    Object.assign({}, dataSet, {
                      correct: true,
                      score: Math.max(json.score, dataSet.score)
                    }),
                    ...dataSets.slice(dataSetIndex + 1)
                  ]
                }),
                ...problems.slice(problemIndex + 1)
              ]
            })
          })
        }
        this.setState(state);
        break;

      case 403: throw new Error('403 forbidden');
      case 404: throw new Error('404 not found');
      default: throw new Error('unexpected http status');
    }
  }

  public async fetchRanking() {
    const response: Response = await fetch(`/api/contests/${this.props.params.contestId}/ranking${t('locale')}`, {
      credentials: 'same-origin'
    });

    let users: [ UserScoreObject ];
    switch(response.status) {
      case 200:
        const json: any = await response.json();
        users = json.users.map((user: any) => ({
          id: user.id,
          totalScore: user.total_score,
          name: user.name,
          problems: user.problems.map((problem: any) => ({
            id: problem.id,
            dataSets: problem.data_sets.map((dataSet: any) => ({
              id: dataSet.id,
              label: dataSet.label,
              correct: dataSet.correct,
              score: dataSet.score,
              solvedAt: dataSet.solved_at ? new Date(dataSet.solved_at) : null,
              wrongAnswers: dataSet.wrong_answers,
            }))
          }))
        }));
        break;

      case 403: throw new Error('403 forbidden');
      case 404: throw new Error('404 not found');
    }

    this.setState({ users })

    if(!this.rankingRequestTimerId) {
      this.rankingRequestTimerId = setInterval(this.fetchRanking.bind(this), 60 * 1000);
    }
  }

  public closeSubmitResults() {
    this.setState(Object.assign({}, this.state, {
      submitResults: []
    }));
  }

  public async initTimer() {
    const time = await this.fetchTime();
    const now = new Date();

    if(now <= time.startAt){
      setInterval(function() {
        this.beforeContestTimer(time.startAt);
      }.bind(this), 1000);
    }
  }

  public async beforeContestTimer(startAt: Date) {
    const now = new Date();
    let startTime = startAt;

    if(now < startAt) {
    } else if (now >= startTime) {
      alert("コンテストを開始します");
      location.reload();
    }
  }

  public async fetchTime() {
    let fetchedTime: TimerObject;
    const responseTime: Response = await fetch(`/api/contests/${this.props.params.contestId}${t('locale')}`, {
      credentials: 'same-origin',
    });

    switch(responseTime.status) {
      case 200:
        const json: any = await responseTime.json();
        fetchedTime = {
          startAt: new Date(json.start_at),
          endAt: new Date(json.end_at)
        }
        break;
      case 404: throw new Error('404 not found');
      default: throw new Error('unexpected http status');
    }
    return fetchedTime;
  }

  public changeAnswerForm(problemId: number, dataSetId: number, answer: string) {
    const contest = this.state.contest;
    const problems = contest.problems;
    const problemIndex = problems.findIndex((problem) => problem.id === problemId);
    const problem = problems[ problemIndex ];
    const dataSets = problem.dataSets;
    const dataSetIndex = dataSets.findIndex((dataSet) => dataSet.id === dataSetId);
    const dataSet = dataSets[ dataSetIndex ];

    this.setState({
      contest: Object.assign({}, contest, {
        problems: [
          ...problems.slice(0, problemIndex),
          Object.assign({}, problem, {
            dataSets: [
              ...dataSets.slice(0, dataSetIndex),
              Object.assign({}, dataSet, {
                answer: answer
              }),
              ...dataSets.slice(dataSetIndex + 1)
            ]
          }),
          ...problems.slice(problemIndex + 1)
        ]
      })
    });
  }

  public render() {
    if(!this.state.initialized) {
      return (
        <div className="container">
          <div>Now Initializing...</div>
        </div>
      )
    }

    return (
      <div className="container">
        <Navigation
          contest={ this.state.contest }
        />
        { this.props.children && this.props.children.type === ContestHome &&
          <ContestHome
            contest={ this.state.contest }
            join={ this.join.bind(this) }
          />
        }
        { this.props.children && this.props.children.type === Problem && this.state.contest.problems &&
          <Problem
            contest={ this.state.contest }
            problem={ this.state.contest.problems.find((problem) => problem.id === +this.props.params.problemId) }
            changeAnswerForm={ this.changeAnswerForm.bind(this) }
            submit={ this.submit.bind(this) }
          />
        }
        { this.props.children && this.props.children.type === Submissions &&
          <Submissions
            contest={ this.state.contest }
            submissions={ this.state.submissions }
          />
        }
        { this.props.children && this.props.children.type === Ranking && this.state.users &&
          <Ranking
            contest={ this.state.contest }
            users={ this.state.users }
          />
        }
        { this.state.submissions &&
          <SubmitResults
            submissions={ this.state.submissions }
            submitResults={ this.state.submitResults }
            closeSubmitResults={ this.closeSubmitResults.bind(this) }
          />
        }
      </div>
    );
  }
}
