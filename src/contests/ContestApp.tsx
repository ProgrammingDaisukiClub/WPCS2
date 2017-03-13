import * as React from 'react';

import ContestObject from 'contests/ContestObject';
import ProblemObject from 'contests/ProblemObject';
import DataSetObject from 'contests/DataSetObject';

import Navigation from 'contests/Navigation';
import ContestHome from 'contests/ContestHome';
import Problem from 'contests/Problem';
import Submissions from 'contests/Submissions';
import Ranking from 'contests/Ranking';

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
}

export default class ContestApp extends React.Component<ContestAppProps, ContestAppState> {
  private csrfParam: string;
  private csrfToken: string;

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
  }

  public componentDidMount() {
    this.setBorderHeight();
  }

  public componentDidUpdate() {
    this.setBorderHeight();
  }

  public fetchContest() {
    fetch(`/api/contests/${this.props.params.contestId}`, {
      credentials: 'same-origin',
    })
    .then((response: Response) => {
      switch(response.status) {
        case 200: return response.json();
        case 404:
        default: throw new Error;
      }
    })
    .then((json: any) => {
      let state: ContestAppState = {
        initialized: true,
        contest: {
          id: json.id,
          name: json.name,
          description: json.description,
          joined: json.joined,
          startAt: new Date(json.start_at),
          endAt: new Date(json.end_at)
        }
      };
      if(json.problems) {
        Object.assign(state.contest, {
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
      this.setState(state);
    })
    .catch((error: Error) => console.error(error));
  }

  public join() {
    const formData: FormData = new FormData();
    formData.append(this.csrfParam, this.csrfToken);
    fetch(`/api/contests/${this.props.params.contestId}/entry`, {
        method: "post",
        credentials: 'same-origin',
        body: formData
      })
    .then((response: Response) => {
      switch(response.status) {
        case 201: return response.json();
        case 403:
        case 404:
        case 409:
        default: throw new Error;
      }
    })
    .then(() => {
      this.fetchContest();
    })
    .catch((error: Error) => console.error(error));
  }

  public submit(problemId: number, dataSetId: number, answer: string) {
    const formData: FormData = new FormData();
    formData.append(this.csrfParam, this.csrfToken);
    formData.append('answer', answer);
    fetch(`/api/contests/${this.props.params.contestId}/submissions`, {
      method: 'post',
      credentials: 'same-origin',
      body: formData
    })
    .then((response: Response) => {
      switch(response.status) {
        case 201: return response.json();
        case 403:
        case 404:
        default: throw new Error;
      }
    })
    .then((json: any) => {
      const contest: ContestObject = this.state.contest;
      const problems: [ProblemObject] = contest.problems;
      const problemIndex: number = problems.findIndex((problem) => problem.id === problemId);
      const problem: ProblemObject = problems[problemIndex];
      const dataSets: [DataSetObject] = problem.dataSets;
      const dataSetIndex: number = dataSets.findIndex((dataSet) => dataSet.id === dataSetId);
      const dataSet: DataSetObject = dataSets[dataSetIndex];

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
    })
    .catch((error: Error) => console.error(error));
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
        { this.props.children && this.props.children.type === Submissions &&
          this.props.children
        }
        { this.props.children && this.props.children.type === Ranking &&
          this.props.children
        }
      </div>
    );
  }
}
