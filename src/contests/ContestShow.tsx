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
      return (<div className='center'><button className='btn'>参加する</button></div>);
    }
  }

  public render() {
    return (
      <div className='contest-main'>
        <div> 
          <div className='contest-header'> <span className='contest-title'>{ this.props.name }</span> </div>
          <div className='contest-body clearfix'>
            { this.renderButton() }
            { this.props.description }
            <br />
            <h4> プログラミングコンテストとは？</h4>
            <p> プログラミングコンテストは〜 </p>
            <h4> ルール </h4>
            <h4> 問題 </h4>
          </div>  
        </div>
      </div>
    );
  }
}
