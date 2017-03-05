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
    this.onSubmit = this.onSubmit.bind(this);
    this.onChange = this.onChange.bind(this);
    this.onClick = this.onClick.bind(this);
    this.state = {
      answer : ''
    };
  }

  public submit(id: number, answer: string) {
    console.log(id, answer);
  }

  private onSubmit(event: React.FormEvent<HTMLElement>) {
    event.preventDefault();
    this.submit(this.props.problemId, this.state.answer);
  }

  private onChange(event: React.FormEvent<HTMLElement>) {
    const input : any = event.target;
    this.setState({ answer : input.value });
  }

  private item(name: string, score: number, id: number) {
    return (
      <p key={ id }>{ name + ': ' + score + ' points' }</p>
      );
  }

  private renderButtons(name: string, id: number) {
    return (
      <button name= { String(id) } type='button' key={ id } className='btn-table' onClick={ this.onClick } >{ name }</button>
      );
  }

  private onClick(event: React.MouseEvent<HTMLElement>) {
    const input : any = event.target;
    console.log(input.name);
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
            <form onSubmit= { this.onSubmit } onChange= { this.onChange } >
              <div className='section-body'>
                <div className='submit-form-block'>
                  <div className='submit-form-header'>
                    {  this.props.dataSets.map((data) => { return this.renderButtons(data.label, data.id); } ) }
                  </div>
                  <div key={ 1 } className='submit-form-body show'>
                    1 2 3 4 5 6 7 8 9 <br />
                    2 3 4 5 6 7 8 9 1 <br />
                    1 2 3 4 5 6 7 8 9 <br />
                    2 3 4 5 6 7 8 9 1 <br />
                    1 1 1 1 <br />
                    1 1 1 1 <br />
                  </div>
                  <div key={ 2 } className='submit-form-body hide'>
                    1 2 3 4 5 6 7 8 9 <br />
                    2 3 4 5 6 7 8 9 1 <br />
                    1 2 3 4 5 6 7 8 9 <br />
                    1 1 1 1 <br />
                    1 1 1 1 <br />
                  </div>
                  <div className='submit-form-footer'>
                    <textarea name='answer' className='input-answer' placeholder='Enter your answers here please...'></textarea>
                  </div>
                </div>
              </div>
              <div className='section-footer'>
                <button className='btn' type='submit'> 提出する </button>
              </div>
            </form>
          </div>
        </div>  
      </div>
    );
  }
}
