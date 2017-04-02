import * as React from 'react';

import ProblemObject from 'contests/ProblemObject';
import MarkdownRenderer from 'contests/MarkdownRenderer';

export interface ProblemProps {
  problem: ProblemObject;
  submit: (problemId: number, dataSetId: number, answer: string) => void;
}

export interface ProblemState {
  dataSetTabId: number;
  answer: string;
}

export default class Problem extends React.Component<ProblemProps, ProblemState> {
  constructor(props: ProblemProps) {
    super();

    this.state = {
      dataSetTabId: props.problem.dataSets[0].id,
      answer: ""
    }
  }

  public componentWillReceiveProps(props: ProblemProps) {
    if(this.props.problem.id !== props.problem.id) {
      this.setState({
        dataSetTabId: props.problem.dataSets[0].id,
      })
    }
  }

  public onFormSubmit(event: React.FormEvent<HTMLElement>) {
    event.preventDefault();
    this.props.submit(this.props.problem.id, this.state.dataSetTabId, this.state.answer);
  }

  public onAnswerChange(event: React.FormEvent<HTMLElement> ) {
    const input: HTMLInputElement = event.target as HTMLInputElement;
    this.setState({ answer: input.value });
  }

  public onTabClick(id: number) {
    this.setState({ dataSetTabId: id });
  }

  public render() {
    return (
      <div className="problem">
        <div className="problem--inner">
          <h2 className="problem--header">{ this.props.problem.name }</h2>
          <div className="problem--body">
            <div className="problem--score">
              <div className="problem--scoreHeader">{ t('score') }</div>
              { this.props.problem.dataSets.map((dataSet) => (
                <div className="problem--scoreBody" key={ dataSet.id }>
                  { dataSet.label }: { dataSet.maxScore } points
                </div>
              )) }
            </div>
            <div className="problem--description">
              <div className="problem--descriptionBody">
                <MarkdownRenderer text= { this.props.problem.description } />
              </div>
            </div>
            <div className="problem--submission">
              <div className="problem--submissionHeader">{ t('submission') }</div>
              <form onSubmit={ (e) => this.onFormSubmit(e) }>
                <div className="problem--submissionForm">
                  <div className="problem--submissionDataSets">
                    <ul className="problem--dataSetTabs">
                      { this.props.problem.dataSets.map((dataSet) => (
                        <li
                          key={ dataSet.id }
                          className={ `problem--dataSetTab${ dataSet.id === this.state.dataSetTabId ? '__active' : '' }` }
                          onClick={ () => this.onTabClick(dataSet.id) }>
                          { dataSet.label }
                        </li>
                      )) }
                    </ul>
                    { /* <a className="problem--dataSetDownloadLink" href="#">Download</a> */ }
                  </div>
                  <textarea
                    className="problem--answer"
                    name="answer" placeholder="Type Answer ..." value={ this.state.answer }
                    rows={ Math.max(6, Math.min(18, this.state.answer.split("\n").length))}
                    onChange={ (e) => this.onAnswerChange(e) }
                  />
                </div>
                <div className="problem--submitWrapper">
                  <input className="problem--submit" type="submit" value={ t('submit') } />
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
