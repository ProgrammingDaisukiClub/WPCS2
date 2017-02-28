import * as React from 'react';
import { Link } from 'react-router';

export interface ContestAppProps extends React.Props<ContestApp> {
  params: {
    contestId: string;
  };
}

export interface ContestAppState {
  initialized: boolean;
}

export default class ContestApp extends React.Component<ContestAppProps, ContestAppState> {
  constructor(props: ContestAppProps) {
    super(props);
    this.state = {
      initialized: false
    };
  }

  public render() {
    return (
      <div>
        <div>
          <div>Navigation</div>
          <ul>
            <li><Link to={ `/contests/${this.props.params.contestId}` }>Contest Home</Link></li>
            <li>
              <div>Problems</div>
              <ul>
              </ul>
            </li>
            <li><Link to={ `/contests/${this.props.params.contestId}/ranking` }>Ranking</Link></li>
          </ul>
        </div>
        <div>
          <div>Main Contents</div>
          { this.props.children }
        </div>
      </div>
    );
  }
}
