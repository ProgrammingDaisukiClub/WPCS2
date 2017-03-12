import * as React from 'react';
import { Link } from 'react-router';

import ContestObject from 'contests/ContestObject';
import ProblemObject from 'contests/ProblemObject';
import DataSetObject from 'contests/DataSetObject';

export interface NavigationProps extends React.Props<Navigation> {
  contest: ContestObject;
}

export default class Navigation extends React.Component<NavigationProps, {}> {
  constructor(props: NavigationProps) {
    super(props);
    this.state = {};
  }

  public render() {
    return (
      <div className="contestNavigation">
        <nav className="contestNavigation--inner">
          <h2 className="contestNavigation--header">{ this.props.contest.name }</h2>
          <Link className="contestNavigation--homeLink" to={ `/contests/${this.props.contest.id}` }>Contest Home</Link>
          { this.props.contest.problems &&
            this.props.contest.problems.map((problem: ProblemObject) => (
              <div key={ problem.id } className="contestNavigation--problem">
                <Link className="contestNavigation--problemLink" key={ problem.id } to={ `/contests/${this.props.contest.id}/problems/${problem.id}` }>
                  { problem.name }
                </Link>
                { problem.dataSets.map((dataSet: DataSetObject) => (
                  <div key={ dataSet.id } className="contestNavigation--dataSet">
                    { dataSet.label }: { dataSet.score }/{ dataSet.maxScore }
                  </div>
                )) }
              </div>
            ))
          }
          { this.props.contest.problems &&
            <Link className="contestNavigation--rankingLink" to={ `/contests/${this.props.contest.id}/ranking` }>Ranking</Link>
          }
        </nav>
      </div>
    );
  }
}
