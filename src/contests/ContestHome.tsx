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
    const now = new Date();
    if(this.props.contest.joined || now > this.props.contest.endAt) {
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
      <div className='contest'>
        <div className='contest__header'>
          <span className='contest__header__title'>{ this.props.contest.name }</span>
        </div>
        <div className='contest__body contest--clearfix'>
          { this.renderButton() }
          { this.props.contest.description }
        </div>
      </div>
    );
  }
}
