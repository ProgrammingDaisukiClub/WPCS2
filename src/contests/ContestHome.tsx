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

  private renderButton() {
    const now: Date = new Date();
    if(this.props.contest.joined || this.props.contest.endAt < now) {
      return null
    }

    return (
      <div className='contest__body--center'>
        <div className='contest__body__btn' onClick={ this.onJoinButtonClick.bind(this) }>
          参加する
        </div>
      </div>
    );
  }

  public render() {
    return (
      <div className='contestHome'>
        <div className='contestHome__header'>
          <span className='contestHome__header__title'>{ this.props.contest.name }</span>
        </div>
        <div className='contestHome__body contestHome--clearfix'>
          { this.renderButton() }
          { this.props.contest.description }
        </div>
      </div>
    );
  }
}
