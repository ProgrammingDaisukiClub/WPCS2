import * as React from 'react';

export interface Props {
  problemId: number;
  dataSets: [
    {
      id: number;
      label: string;
      score: number;
      testCase: string;
    }
  ];
  submit: (id: number, answer: string) => void;
}

export interface State {
  answer: string;
  selected: number;
}

export default class ProblemFormTabs extends React.Component<Props, State> {

  constructor(props: Props) {
    super(props);
    this.onSubmit = this.onSubmit.bind(this);
    this.onChange = this.onChange.bind(this);
    this.onClick = this.onClick.bind(this);
    this.state = {
      answer : '',
      selected : 0
    };
  }

  private onSubmit(event: React.FormEvent<HTMLElement>) {
    event.preventDefault();
    this.props.submit(this.props.problemId, this.state.answer);
  }

  private onChange(event: React.FormEvent<HTMLElement> ) {
    const input : any = event.target;
    this.setState({ answer : input.value });
  }

  private onClick(index: number, event: React.MouseEvent<HTMLElement>) {
    event.preventDefault();
    this.setState({
      selected: index
    });
  }

  private renderLabels(child: { id: number; label: string; score: number; testCase: string; }, index: number) {
    const activeClass = (this.state.selected === index ? 'active' : '');
    return (
      <li key={ index }>
        <a href='' role='main' className= { activeClass } onClick= { this.onClick.bind(this, index) }>
          { child.label }
        </a>
      </li>
      );
  }

  private renderTitles() {
    return (
      <div className='problem__form__header'>
        <ul className='problem__tabs'>  
          { this.props.dataSets.map(this.renderLabels.bind(this)) }
        </ul>
      </div>
    );
  }

  private renderContents() {
    return (
      <div className='problem__form__body'>
        { this.props.dataSets[this.state.selected].testCase }
      </div>
    );
  }

  public render() {
    return (
      <form onSubmit= { this.onSubmit } onChange= { this.onChange } >
        <div className='problem__section__body'>
          <div className='problem__form'>
            { this.renderTitles() }
            { this.renderContents() }
            <div className='problem__form__footer'>
              <textarea name='answer' className='problem__form__input' value={ this.state.answer } placeholder='Type Answer...'></textarea>
            </div>
          </div>
        </div>
        <div className='problem__section__footer'>
          <button className='problem__form__btn' type='submit'> 提出する </button>
        </div>
      </form>
    );
  }
}
