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
  submit: (id: number, answer: string, typeId: number) => void;
}

export interface State {
  answer: string;
}

export default class ProblemMain extends React.Component<Props, State> {

  constructor(props: Props) {
    super(props);
    this.state = {
      answer : ''
    };
  }

  private item(name: string, score: number, id: number) {
    return (
      <p key={ id }>{ name + ': ' + score + ' points' }</p>
      );
  }

  public render() {
    return (
      <div className='problem'>
        <div className='problem__header'> <span className='problem__header__title'>{ this.props.name }</span> </div>
        <div className='problem__body problem__body--clearfix'>
          <div className='problem__section'>
            <div className='problem__section__header'>配点</div>
            <div className='problem__section__body'>
              { this.props.dataSets.map((data) => { return this.item(data.label, data.score, data.id); } ) }
            </div>
          </div>
          <div className='problem__section'>
            <div className='problem__section__header'>問題</div>
            <div className='problem__section__body'>
              <p> { this.props.description } </p>
            </div>
          </div>
          <div className='problem__section'>
            <div className='problem__section__header'>提出</div>
            <ProblemFormTabs dataSets={ this.props.dataSets } problemId={ this.props.problemId } submit={ this.props.submit }/>
          </div>
        </div>  
      </div>
    );
  }
}
