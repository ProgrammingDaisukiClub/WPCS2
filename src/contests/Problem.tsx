import ProblemMain from 'contests/ProblemMain';
import * as React from 'react';

export default class Problem extends React.Component<{}, {}> {

  public render() {
    const dataSets : [{ id: number; label: string; score: number; testCase: string; }] = [
      { id: 1, label: 'Small', score: 10, testCase: 'test-small'},
      { id: 2, label: 'Large', score: 10, testCase: 'test-large'}
    ];
    return (
      <div className='main'>
        <div className='problem-nav'>
            
        </div>
        <ProblemMain problemId={ 1 } name='A 鉛筆リサイクルの最新技術' description='hahaha' dataSets={ dataSets } />
      </div>
    );
  }
}
