import * as React from 'react';

import ContestObject from 'contests/ContestObject';
import ProblemObject from 'contests/ProblemObject';
import DataSetObject from 'contests/DataSetObject';

import Navigation from 'contests/Navigation';
import ContestHome from 'contests/ContestHome';
import Problem from 'contests/Problem';

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
  // submissions: [ SubmissionObject ];
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
      initialized: false
    };
  }

  public componentWillMount() {
    this.fetchContest();
    this.fetchRanking();
  }

  public componentDidMount() {
    this.rankingRequestTimerId = setInterval(this.fetchRanking.bind(this), 60 * 1000);

    this.setBorderHeight();
  }

  public componentDidUpdate() {
    this.setBorderHeight();
  }

  public componentWillUnmount() {
    if(this.rankingRequestTimerId) {
      clearInterval(this.rankingRequestTimerId);
    }
  }

  public async fetchContest() {
    const requestContests: Promise<Response> = fetch(`/api/contests/${this.props.params.contestId}`, {
      credentials: 'same-origin',
    });
    const requestSubmissions: Promise<Response> = fetch(`/api/contests/${this.props.params.contestId}/submissions`, {
      credentials: 'same-origin',
    });
    const responses: [ Response ] = await Promise.all([requestContests, requestSubmissions]);
    const responseContest: Response = responses[0];
    const responseSubmissions: Response = responses[1];

    let contest: ContestObject;
    switch(responseContest.status) {
      case 200:
        const json: any = await responseContest.json();
        contest = {
          id: json.id,
          name: json.name,
          description: json.description,
          joined: json.joined,
          startAt: new Date(json.start_at),
          endAt: new Date(json.end_at)
        };
        if(json.problems) {
          Object.assign(contest, {
            problems: json.problems.map((problem: any) => ({
              id: problem.id,
              name: problem.name,
              description: problem.description,
              dataSets: problem.data_sets.map((dataSet: any) => ({
                id: dataSet.id,
                label: dataSet.label,
                maxScore: dataSet.max_score,
                correct: dataSet.correct,
                score: dataSet.score
              }))
            }))
          });
        }
        break;

      case 404: throw new Error('404 not found');
      default: throw new Error('unexpected http status');
    }

    // let submissions: [ SubmissionObject ];
    switch(responseSubmissions.status) {
      case 200:
        // TODO
        break;

      case 403: throw new Error('403 forbidden');
      case 404: throw new Error('404 not found');
      default: throw new Error('unexpected http status');
    }

    this.setState({
      initialized: true,
      contest,
      // submissions,
    });
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

  public async submit(problemId: number, dataSetId: number, answer: string) {
    const formData: FormData = new FormData();
    formData.append(this.csrfParam, this.csrfToken);
    formData.append('answer', answer);

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

        let state: ContestAppState = Object.assign({}, this.state);
        if(!dataSet.correct && json.correct) {
          Object.assign(state, {
            contest: Object.assign({}, contest, {
              problems: [
                ...problems.slice(0, problemIndex),
                Object.assign({}, problem, {
                  dataSets: [
                    ...dataSets.slice(0, dataSetIndex),
                    Object.assign({}, dataSet, {
                      correct: true,
                      score: json.score
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
    const response: Response = await fetch(`/api/contests/${this.props.params.contestId}/ranking`, {
      credentials: 'same-origin'
    });

    switch(response.status) {
      case 200:
        // TODO
        break;

      case 403: throw new Error('403 forbidden');
      case 404: throw new Error('404 not found');
    }
  }

  public setBorderHeight() {
    const container: HTMLElement = document.querySelector('.container') as HTMLElement;
    const border: HTMLElement = document.querySelector('.container--border') as HTMLElement;
    if(!container || !border) return;
    border.style.height = container.clientHeight + 'px';
  }

  public render() {
    if(!this.state.initialized) {
      return <div>now initializing...</div>;
    }

    return (
      <div className="container">
        <Navigation
          contest={ this.state.contest }
        />
        <div className="container--border"></div>
        { this.props.children && this.props.children.type === ContestHome &&
          <ContestHome
            contest={ this.state.contest }
            join={ this.join.bind(this) }
          />
        }
        { this.props.children && this.props.children.type === Problem &&
          <Problem
            problem={ this.state.contest.problems.find((problem) => problem.id === +this.props.params.problemId) }
            submit={ this.submit.bind(this) }
          />
        }
      </div>
    );
  }
}
