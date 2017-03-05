import ProblemFormTabs from 'contests/ProblemFormTabs';
import * as React from 'react';

export interface Props {
  problemId: number;
  name: string;
  description: string;
  dataSets: [
    {
      id: number;
      label: string;
      score: number;
      testCase: string;
    }
  ];
}

export interface State {
  answer: string;
}

export default class ProblemMain extends React.Component<Props, State> {

  constructor(props: Props) {
    super(props);
    this.submit = this.submit.bind(this);
    this.state = {
      answer : ''
    };
  }

  public submit(id: number, answer: string, typeId: number) {
    console.log(id, answer, typeId);
  }

  private item(name: string, score: number, id: number) {
    return (
      <p key={ id }>{ name + ': ' + score + ' points' }</p>
      );
  }

  public render() {
    return (
      <div className='problem-main'>
        <div className='problem-header'> <span className='problem-title'>{ this.props.name }</span> </div>
        <div className='problem-body clearfix'>
          <div className='section'>
            <div className='section-header'>配点</div>
            <div className='section-body'>
              { this.props.dataSets.map((data) => { return this.item(data.label, data.score, data.id); } ) }
            </div>
          </div>
          <div className='section'>
            <div className='section-header'>問題</div>
            <div className='section-body'>
              <p> { this.props.description } </p>
            </div>
          </div>
          <div className='section'>
            <div className='section-header'>提出</div>
            <ProblemFormTabs dataSets={ this.props.dataSets } problemId={ this.props.problemId } submit={ this.submit }/>
          </div>
        </div>  
      </div>
    );
  }
}
