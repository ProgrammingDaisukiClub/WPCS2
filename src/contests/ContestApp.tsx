import * as React from 'react';
import { Route, Switch } from 'react-router-dom';

import ContestObject from 'contests/ContestObject';
import DataSetObject from 'contests/DataSetObject';
import ProblemObject from 'contests/ProblemObject';
import SubmissionObject from 'contests/SubmissionObject';
import TimerObject from 'contests/TimerObject';
import UserScoreObject from 'contests/UserScoreObject';

import JUDGE_STATUS from 'contests/JUDGE_STATUS';

import ContestHome from 'contests/ContestHome';
import Editorial from 'contests/Editorial';
import Navigation from 'contests/Navigation';
import Problem from 'contests/Problem';
import Ranking from 'contests/Ranking';
import Submissions from 'contests/Submissions';
import SubmitResults from 'contests/SubmitResults';

export interface ContestAppProps extends React.Props<ContestApp> {
  children: React.ReactElement<any>;
  match: {
    params: {
      contestId: string;
      problemId: string;
    };
  };
}

export interface ContestAppState {
  initialized: boolean;
  contest?: ContestObject;
  submissions?: SubmissionObject[];
  users?: UserScoreObject[];
  submitResults: number[];
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
      submitResults: [] as [number],
    };
  }

  public componentWillMount(): void {
    this.fetchContest();
  }

  public componentWillUnmount(): void {
    if (this.rankingRequestTimerId !== 0) {
      clearInterval(this.rankingRequestTimerId);
    }
  }

  public componentDidMount(): void {
    this.initTimer();
  }

  public async fetchContest(): Promise<void> {
    const responseContest: Response = await fetch(`/api/contests/${this.props.match.params.contestId}${t('locale')}`, {
      credentials: 'same-origin',
    });

    let contest: ContestObject;
    switch (responseContest.status) {
      case 200:
        const json: any = await responseContest.json();
        contest = {
          id: json.id,
          name: json.name,
          description: json.description,
          joined: json.joined,
          currentUserId: json.current_user_id,
          adminRole: json.admin_role,
          startAt: new Date(json.start_at),
          endAt: new Date(json.end_at),
          baseline: json.baseline,
          contest_status: json.contest_status,
        };
        if (json.problems) {
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
                answer: '',
              })),
            })),
          });
        }
        if (json.editorial) {
          Object.assign(contest, {
            editorial: json.editorial,
          });
        }
        break;

      case 404:
        throw new Error('404 not found');
      default:
        throw new Error('unexpected http status');
    }

    let submissions: SubmissionObject[];
    if (contest.problems) {
      const responseSubmissions: Response = await fetch(
        `/api/contests/${this.props.match.params.contestId}/submissions${t('locale')}`,
        {
          credentials: 'same-origin',
        }
      );

      switch (responseSubmissions.status) {
        case 200:
          const json: any = await responseSubmissions.json();
          submissions = json.map((submission: any) => ({
            id: submission.id,
            problemId: submission.problem_id,
            dataSetId: submission.data_set_id,
            judgeStatus: submission.judge_status,
            score: submission.score || 0,
            createdAt: new Date(submission.created_at),
          }));
          break;

        case 403:
          throw new Error('403 forbidden');
        case 404:
          throw new Error('404 not found');
        default:
          throw new Error('unexpected http status');
      }
    }

    this.setState({
      initialized: true,
      contest,
      submissions,
    });

    if (contest.problems !== undefined) {
      this.fetchRanking();
    }
  }

  public async join(): Promise<void> {
    const formData: FormData = new FormData();
    formData.append(this.csrfParam, this.csrfToken);

    const response: Response = await fetch(`/api/contests/${this.props.match.params.contestId}/entry`, {
      method: 'post',
      credentials: 'same-origin',
      body: formData,
    });

    switch (response.status) {
      case 201:
        this.fetchContest();
        break;

      case 403:
        throw new Error('403 forbidden');
      case 404:
        throw new Error('404 not found');
      case 409:
        throw new Error('409 conflict');
      default:
        throw new Error('unexpected http status');
    }
  }

  public async submit(problemId: number, dataSetId: number): Promise<void> {
    const contest: ContestObject = this.state.contest;
    const problems: ProblemObject[] = contest.problems;
    const problemIndex: number = problems.findIndex((problem: ProblemObject) => problem.id === problemId);
    const problem: ProblemObject = problems[problemIndex];
    const dataSets: DataSetObject[] = problem.dataSets;
    const dataSetIndex: number = dataSets.findIndex((dataSet: DataSetObject) => dataSet.id === dataSetId);
    const dataSet: DataSetObject = dataSets[dataSetIndex];

    const formData: FormData = new FormData();
    formData.append(this.csrfParam, this.csrfToken);
    formData.append('data_set_id', dataSetId.toString());
    formData.append('answer', dataSet.answer);

    this.changeAnswerForm(problemId, dataSetId, '');

    const response: Response = await fetch(`/api/contests/${this.props.match.params.contestId}/submissions`, {
      method: 'post',
      credentials: 'same-origin',
      body: formData,
    });

    switch (response.status) {
      case 201:
        const json: any = await response.json();
        const contest: ContestObject = this.state.contest;
        const problems: ProblemObject[] = contest.problems;
        const problemIndex: number = problems.findIndex((problem: ProblemObject) => problem.id === problemId);
        const problem: ProblemObject = problems[problemIndex];
        const dataSets: DataSetObject[] = problem.dataSets;
        const dataSetIndex: number = dataSets.findIndex((dataSet: DataSetObject) => dataSet.id === dataSetId);
        const dataSet: DataSetObject = dataSets[dataSetIndex];

        const state: ContestAppState = {
          ...this.state,
          submissions: this.state.submissions.concat({
            id: json.id,
            problemId: json.problem_id,
            dataSetId: json.data_set_id,
            judgeStatus: json.judge_status,
            score: json.score || 0,
            createdAt: new Date(json.created_at),
          }),
          submitResults: this.state.submitResults.concat(json.id),
        };
        if (json.judge_status === JUDGE_STATUS.AC) {
          Object.assign(state, {
            contest: {
              ...contest,
              problems: [
                ...problems.slice(0, problemIndex),
                {
                  ...problem,
                  dataSets: [
                    ...dataSets.slice(0, dataSetIndex),
                    {
                      ...dataSet,
                      correct: true,
                      score: Math.max(json.score, dataSet.score),
                    },
                    ...dataSets.slice(dataSetIndex + 1),
                  ],
                },
                ...problems.slice(problemIndex + 1),
              ],
            },
          });
        }
        this.setState(state);
        break;

      case 403:
        throw new Error('403 forbidden');
      case 404:
        throw new Error('404 not found');
      default:
        throw new Error('unexpected http status');
    }
  }

  public async fetchRanking(): Promise<void> {
    const response: Response = await fetch(`/api/contests/${this.props.match.params.contestId}/ranking${t('locale')}`, {
      credentials: 'same-origin',
    });

    let users: UserScoreObject[];
    switch (response.status) {
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
            })),
          })),
        }));
        break;

      case 403:
        throw new Error('403 forbidden');
      case 404:
        throw new Error('404 not found');
      default:
    }

    this.setState({ users });

    if (!this.rankingRequestTimerId) {
      this.rankingRequestTimerId = setInterval(this.fetchRanking.bind(this), 60 * 1000);
    }
  }

  public closeSubmitResults(): void {
    this.setState({
      ...this.state,
      submitResults: [],
    });
  }

  public async initTimer(): Promise<void> {
    const time: TimerObject = await this.fetchTime();
    const now: Date = new Date();

    if (now <= time.startAt) {
      setInterval(() => {
        this.beforeContestTimer(time.startAt);
      }, 1000);
    }
  }

  public async beforeContestTimer(startAt: Date): Promise<void> {
    const now: Date = new Date();
    const startTime: Date = startAt;

    if (now < startAt) {
      //
    } else if (now >= startTime) {
      alert('コンテストを開始します');
      location.reload();
    }
  }

  public async fetchTime(): Promise<TimerObject> {
    let fetchedTime: TimerObject;
    const responseTime: Response = await fetch(`/api/contests/${this.props.match.params.contestId}${t('locale')}`, {
      credentials: 'same-origin',
    });

    switch (responseTime.status) {
      case 200:
        const json: any = await responseTime.json();
        fetchedTime = {
          startAt: new Date(json.start_at),
          endAt: new Date(json.end_at),
        };
        break;
      case 404:
        throw new Error('404 not found');
      default:
        throw new Error('unexpected http status');
    }

    return fetchedTime;
  }

  public changeAnswerForm(problemId: number, dataSetId: number, answer: string): void {
    const contest: ContestObject = this.state.contest;
    const problems: ProblemObject[] = contest.problems;
    const problemIndex: number = problems.findIndex((problem: ProblemObject) => problem.id === problemId);
    const problem: ProblemObject = problems[problemIndex];
    const dataSets: DataSetObject[] = problem.dataSets;
    const dataSetIndex: number = dataSets.findIndex((dataSet: DataSetObject) => dataSet.id === dataSetId);
    const dataSet: DataSetObject = dataSets[dataSetIndex];

    this.setState({
      contest: {
        ...contest,
        problems: [
          ...problems.slice(0, problemIndex),
          {
            ...problem,
            dataSets: [
              ...dataSets.slice(0, dataSetIndex),
              {
                ...dataSet,
                answer: answer,
              },
              ...dataSets.slice(dataSetIndex + 1),
            ],
          },
          ...problems.slice(problemIndex + 1),
        ],
      },
    });
  }

  public render(): JSX.Element {
    if (!this.state.initialized) {
      return (
        <div className="container">
          <div>Now Initializing...</div>
        </div>
      );
    }

    return (
      <div className="container">
        <Navigation contest={this.state.contest} />
        <Switch>
          <Route
            exact={true}
            path="/contests/:contestId"
            render={(): JSX.Element => <ContestHome contest={this.state.contest} join={this.join.bind(this)} />}
          />;
          <Route
            exact={true}
            path="/contests/:contestId/problems/:problemId"
            render={(props: any): JSX.Element => {
              return !this.state.contest.problems ? null : (
                <Problem
                  contest={this.state.contest}
                  problem={this.state.contest.problems.find(
                    (problem: ProblemObject) => problem.id === +props.match.params.problemId
                  )}
                  changeAnswerForm={this.changeAnswerForm.bind(this)}
                  submit={this.submit.bind(this)}
                />
              );
            }}
          />
          <Route
            exact={true}
            path="/contests/:contestId/ranking"
            render={(): JSX.Element => {
              return !this.state.users ? null : <Ranking contest={this.state.contest} users={this.state.users} />;
            }}
          />
          <Route
            exact={true}
            path="/contests/:contestId/submissions"
            render={(): JSX.Element => (
              <Submissions contest={this.state.contest} submissions={this.state.submissions} />
            )}
          />
          <Route
            exact={true}
            path="/contests/:contestId/editorials/:editorialId"
            render={(): JSX.Element => <Editorial editorial={this.state.contest.editorial} />}
          />
        </Switch>
        {this.state.submissions && (
          <SubmitResults
            submissions={this.state.submissions}
            submitResults={this.state.submitResults}
            closeSubmitResults={this.closeSubmitResults.bind(this)}
          />
        )}
      </div>
    );
  }
}
