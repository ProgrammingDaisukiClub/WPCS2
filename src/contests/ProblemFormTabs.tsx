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
  submit: (id: number, answer: string, typeId: number) => void;
}

export interface State {
  answer: string[];
  selected: number;
}

export default class ProblemFormTabs extends React.Component<Props, State> {

  constructor(props: Props) {
    super(props);
    this.onSubmit = this.onSubmit.bind(this);
    this.onChange = this.onChange.bind(this);
    this.onClick = this.onClick.bind(this);
    this.state = {
      answer : [],
      selected : 0
    };
  }

  private onSubmit(event: React.FormEvent<HTMLElement>) {
    event.preventDefault();
    this.props.submit(this.props.problemId, this.state.answer[this.state.selected], this.state.selected);
  }

  private onChange(event: React.FormEvent<HTMLElement> ) {
    const input : any = event.target;
    const answer = this.state.answer;
    answer[this.state.selected] = input.value;
    this.setState({ answer : answer });
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

  private renderInput() {
    let value = this.state.answer[this.state.selected];
    value = value ? value : '';
    return (
      <div className='problem__form__footer'>
        <textarea name='answer' className='problem__form__input' value={ value } placeholder='Enter your answers here please...'></textarea>
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
            { this.renderInput() }
          </div>
        </div>
        <div className='problem__section__footer'>
          <button className='problem__form__btn' type='submit'> 提出する </button>
        </div>
      </form>
    );
  }
}
