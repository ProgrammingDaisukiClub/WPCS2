import * as React from 'react';

import ContestObject from 'contests/ContestObject';

import MarkdownRenderer from 'contests/MarkdownRenderer';

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
            { !this.props.contest.adminRole && this.props.contest.currentUserId && (!this.props.contest.joined && new Date() < this.props.contest.endAt) &&
              <div className="contestHome--registrationButtonWrapper">
                <span className="contestHome--registrationButton" onClick={ this.onJoinButtonClick.bind(this) }>
                  { t('join') }
                </span>
              </div>
            }
            { !this.props.contest.currentUserId &&
              <div className="contestHome--registrationButtonWrapper">
                <a className="contestHome--registrationButton" href="/users/sign_up">{ t('join') }</a>
              </div>
            }
            <MarkdownRenderer text={ this.props.contest.description } />
          </div>
        </div>
      </div>
    );
  }
}
