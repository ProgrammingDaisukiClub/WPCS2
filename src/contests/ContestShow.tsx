import * as React from 'react';

export interface ContestShowProps {
  name: string;
  description: string;
  joined: boolean;
  startAt: Date;
  endAt: Date;
  onJoinButtonClick: () => void;
}

export default class ContestShow extends React.Component<ContestShowProps, {}> {
  constructor(props: ContestShowProps) {
    super(props);
    this.state = {
      initialized: false
    };
  }

  private renderButton() {
    const now = new Date();
    if (!this.props.joined && now < this.props.endAt && now > this.props.startAt) {
      return (<div className='contest__body--center'><button className='contest__body__btn'>参加する</button></div>);
    }
  }

  public render() {
    return (
      <div className='contest'>
        <div className='contest__header'> 
          <span className='contest__header__title'>{ this.props.name }</span> 
        </div>
        <div className='contest__body contest--clearfix'>
          { this.renderButton() }
          { this.props.description }
          <br />
          <h4> プログラミングコンテストとは？</h4>
          <p> プログラミングコンテストは〜 </p>
          <h4> ルール </h4>
          <h4> 問題 </h4>
        </div>  
      </div>
    );
  }
}
