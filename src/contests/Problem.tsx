import * as React from 'react';

import ContestObject from 'contests/ContestObject';
import ProblemObject from 'contests/ProblemObject';
import MarkdownRenderer from 'contests/MarkdownRenderer';

export interface ProblemProps {
  contest: ContestObject;
  problem: ProblemObject;
  changeAnswerForm: (problemId: number, dataSetId: number, answer: string) => void;
  submit: (problemId: number, dataSetId: number) => void;
}

export interface ProblemState {
  dataSetTabId: number;
}

export default class Problem extends React.Component<ProblemProps, ProblemState> {
  private timerId: number;

  constructor(props: ProblemProps) {
    super();

    this.state = {
      dataSetTabId: props.problem.dataSets[0].id
    }
  }

  public componentDidMount() {
    this.timerId = setInterval(() => {
      this.forceUpdate();
    }, 10000)
  }

  public componentWillReceiveProps(props: ProblemProps) {
    if(this.props.problem.id !== props.problem.id) {
      this.setState({
        dataSetTabId: props.problem.dataSets[0].id,
      })
    }
  }

  public componentWillUnmount() {
    clearInterval(this.timerId);
  }

  public selectedDataSet() {
    return this.props.problem.dataSets.find(dataSet => dataSet.id === this.state.dataSetTabId);
  }

  public currentScore(maxScore: number) {
    const pastTime = new Date().getTime() - this.props.contest.startAt.getTime();
    const contestTime = this.props.contest.endAt.getTime() - this.props.contest.startAt.getTime();
    const rate = (contestTime - pastTime) / contestTime;
    const baseline = this.props.contest.baseline;
    const score = Math.floor(maxScore * (rate + baseline) / (1 + baseline));
    return Math.max(score, 0);
  }

  public onFormSubmit(event: React.FormEvent<HTMLElement>) {
    event.preventDefault();
    this.props.submit(this.props.problem.id, this.state.dataSetTabId);
  }

  public onAnswerChange(event: React.FormEvent<HTMLElement> ) {
    const input = event.target as HTMLInputElement;
    this.props.changeAnswerForm(this.props.problem.id, this.state.dataSetTabId, input.value);
  }

  public onTabClick(id: number) {
    this.setState({ dataSetTabId: id });
  }

  public render() {
    return (
      <div className="problem">
        <div className="problem--inner">
          <h2 className="problem--header">{ this.props.problem.task } - { this.props.problem.name }</h2>
          <div className="problem--body">
            <div className="problem--score">
              <div className="problem--scoreHeader">{ t('score') }</div>
              { this.props.problem.dataSets.map((dataSet) => (
                <div className="problem--scoreBody" key={ dataSet.id }>
                  { dataSet.label }: { this.currentScore(dataSet.maxScore) } / { dataSet.maxScore }点
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
              { this.props.contest.currentUserId ?
                <form onSubmit={ (e) => this.onFormSubmit(e) }>
                  <div className="problem--submissionForm">
                    <div className="problem--submissionDataSets">
                      <ul className="problem--dataSetTabs">
                        <li className="problem--dataSetTabHeader">データセット</li>
                        { this.props.problem.dataSets.map((dataSet) => (
                          <li
                            key={ dataSet.id }
                            className={ `problem--dataSetTab${ dataSet.id === this.state.dataSetTabId ? '__active' : '' }` }
                            onClick={ () => this.onTabClick(dataSet.id) }>
                            { dataSet.label }
                          </li>
                        )) }
                      </ul>
                      <a className="problem--dataSetDownloadLink" href={ this.props.problem.id + "/data_sets/"+ this.state.dataSetTabId }>
                        <i className="fa fa-download"></i> { this.selectedDataSet().label + "のダウンロード" }
                      </a>
                    </div>
                    <textarea
                      className="problem--answer"
                      name="answer"
                      placeholder={
                        "作成したプログラムにデータセットを入力して得られた実行結果を入力してください\n" +
                        "データセットはフォーム右上からダウンロードすることができます\n" +
                        "データセットの選択間違いに注意してください"
                      }
                      value={ this.selectedDataSet().answer }
                      rows={ Math.max(6, Math.min(18, this.selectedDataSet().answer.split("\n").length))}
                      onChange={ (e) => this.onAnswerChange(e) }
                    />
                  </div>
                  <div className="problem--submitWrapper">
                    <input className="problem--submit" type="submit" value={ t('submit') } />
                  </div>
                </form> : <p>解答を提出するためにはログインが必要です</p>
              }
            </div>
          </div>
        </div>
      </div>
    );
  }
}
