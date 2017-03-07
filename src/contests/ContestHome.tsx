import * as React from 'react';

import ContestObject from 'contests/ContestObject';

export interface ContestHomeProps {
  contest: ContestObject;
  join: () => void;
}

export default class ContestHome extends React.Component<ContestHomeProps, {}> {
  private onJoinButtonClick() {
    this.props.join();
  }

  public render() {
    return (
      <div className="contestHome">
        <div className="contestHome--inner">
          <h2 className="contestHome--header">{ this.props.contest.name }</h2>
          <div className="contestHome--body">
            { (!this.props.contest.joined && new Date() < this.props.contest.endAt) &&
              <div className="contestHome--registrationButtonWrapper">
                <span className="contestHome--registrationButton" onClick={ this.onJoinButtonClick.bind(this) }>
                  参加する
                </span>
              </div>
            }
            <div className="contestHome--description">
              { this.props.contest.description }
            </div>
          </div>
        </div>
      </div>
    );
  }
}
