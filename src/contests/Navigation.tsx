import * as React from 'react';
import { Link } from 'react-router';

export interface NavigationProps extends React.Props<Navigation> {
  contestId: string;
  problems?: [
    {
      id: number;
      name: string;
    }
  ]
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
          <li><Link to={ `/contests/${this.props.contestId}` }>Contest Home</Link></li>
          {this.props.problems &&
            <li>
              <div>Problems</div>
              <ul>
                {this.props.problems.map((problem) => (
                  <li key={ problem.id }><Link to={ `/contests/${this.props.contestId}/problems/${problem.id}` }>{problem.name}</Link></li>
                ))}
              </ul>
            </li>
          }
          {this.props.problems &&
            <li><Link to={ `/contests/${this.props.contestId}/ranking` }>Ranking</Link></li>
          }
        </ul>
      </div>
    );
  }
}
