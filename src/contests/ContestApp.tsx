import * as React from 'react';
// import { Link } from 'react-router';

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

  // private renderHeader() {
  //   return (
  //     <div>
  //       <ul>
  //         <li><Link to='/contests/'>Contest Home</Link></li>
  //         <li>
  //           <div>Problems</div>
  //           <ul>
  //           </ul>
  //         </li>
  //         <li><Link to='/contests/ranking'>Ranking</Link></li>
  //       </ul>
  //     </div>
  //   );
  // }

  public render() {
    return (
      <div> 
        <div>
          { this.props.children }
        </div>
      </div>
    );
  }
}
