import ContestShow from 'contests/ContestShow';
import * as React from 'react';

export default class ContestHome extends React.Component<{}, {}> {
  private onJoinButtonClick() {
    return 'hello';
  }
  public render() {
    return (
      <div className='main clearfix'>
        <div className='contest-nav'>

        </div>
        <ContestShow
          joined={ false }
          description={ '早稲田大学情報理工学科2年生オリエンテーションで行うプログラミングコンテストです。2年生だけでなく3, 4年生の参加もお待ちしています。コンテスト上位者には商品が出る……かもしれない？' }
          name={ '情理オリエンテーション' }
          endAt={ new Date('2017/3/10') }
          startAt={ new Date('2017/2/28') }
          onJoinButtonClick={ this.onJoinButtonClick }
          />
      </div>
    );
  }
}
