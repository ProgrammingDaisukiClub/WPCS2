import * as React from 'react';
import { Link } from 'react-router';

import ContestObject from 'contests/ContestObject';

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
      <div>
        <div>Navigation</div>
        <ul>
          <li><Link to={ `/contests/${this.props.contest.id}` }>Contest Home</Link></li>
          {this.props.contest.problems &&
            <li>
              <div>Problems</div>
              <ul>
                {this.props.contest.problems.map((problem) => (
                  <li key={ problem.id }><Link to={ `/contests/${this.props.contest.id}/problems/${problem.id}` }>{problem.name}</Link></li>
                ))}
              </ul>
            </li>
          }
          {this.props.contest.problems &&
            <li><Link to={ `/contests/${this.props.contest.id}/ranking` }>Ranking</Link></li>
          }
        </ul>
      </div>
    );
  }
}
