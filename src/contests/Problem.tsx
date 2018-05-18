import * as React from 'react';

import ContestObject from 'contests/ContestObject';
import DataSetObject from 'contests/DataSetObject';
import MarkdownRenderer from 'contests/MarkdownRenderer';
import ProblemObject from 'contests/ProblemObject';

export interface ProblemProps {
  contest: ContestObject;
  problem: ProblemObject;
  changeAnswerForm(problemId: number, dataSetId: number, answer: string): void;
  submit(problemId: number, dataSetId: number): void;
}

export interface ProblemState {
  dataSetTabId: number;
}

export default class Problem extends React.Component<ProblemProps, ProblemState> {
  private timerId: number;

  constructor(props: ProblemProps) {
    super(props);

    this.state = {
      dataSetTabId: props.problem.dataSets[0].id,
    };
  }

  public componentDidMount(): void {
    this.timerId = window.setInterval(() => {
      this.forceUpdate();
    }, 10000);
  }

  public componentWillReceiveProps(props: ProblemProps): void {
    if (this.props.problem.id !== props.problem.id) {
      this.setState({
        dataSetTabId: props.problem.dataSets[0].id,
      });
    }
  }

  public componentWillUnmount(): void {
    clearInterval(this.timerId);
  }

  public selectedDataSet(): DataSetObject {
    return this.props.problem.dataSets.find((dataSet: DataSetObject) => dataSet.id === this.state.dataSetTabId);
  }

  public currentScore(maxScore: number): number {
    const pastTime: number = new Date().getTime() - this.props.contest.startAt.getTime();
    const contestTime: number = this.props.contest.endAt.getTime() - this.props.contest.startAt.getTime();
    const rate: number = (contestTime - pastTime) / contestTime;
    const baseline: number = this.props.contest.baseline;
    const score: number = Math.floor(maxScore * (rate + baseline) / (baseline + 1));

    return Math.max(score, 0);
  }

  public onFormSubmit(event: React.FormEvent<HTMLElement>): void {
    event.preventDefault();
    this.props.submit(this.props.problem.id, this.state.dataSetTabId);
  }

  public onAnswerChange(event: React.FormEvent<HTMLElement>): void {
    const input: HTMLInputElement = event.target as HTMLInputElement;
    this.props.changeAnswerForm(this.props.problem.id, this.state.dataSetTabId, input.value);
  }

  public onTabClick(id: number): void {
    this.setState({ dataSetTabId: id });
  }

  public render(): JSX.Element {
    return (
      <div className="problem">
        <div className="problem--inner">
          <h2 className="problem--header">
            {this.props.problem.task} - {this.props.problem.name}
          </h2>
          <div className="problem--body">
            <div className="problem--score">
              <div className="problem--scoreHeader">{t('score')}</div>
              {this.props.problem.dataSets.map((dataSet: DataSetObject) => (
                <div className="problem--scoreBody" key={dataSet.id}>
                  {dataSet.label}: {this.currentScore(dataSet.maxScore)} / {dataSet.maxScore}点
                </div>
              ))}
            </div>
            <div className="problem--description">
              <div className="problem--descriptionBody">
                <MarkdownRenderer text={this.props.problem.description} />
              </div>
            </div>
            <div className="problem--submission">
              <div className="problem--submissionHeader">{t('submission')}</div>
              {this.props.contest.currentUserId ? (
                <form
                  onSubmit={(e: React.FormEvent<HTMLFormElement>): void => {
                    this.onFormSubmit(e);
                  }}
                >
                  <div className="problem--submissionForm">
                    <div className="problem--submissionDataSets">
                      <ul className="problem--dataSetTabs">
                        <li className="problem--dataSetTabHeader">データセット</li>
                        {this.props.problem.dataSets.map((dataSet: DataSetObject) => (
                          <li
                            role="button"
                            key={dataSet.id}
                            className={`problem--dataSetTab${dataSet.id === this.state.dataSetTabId ? '__active' : ''}`}
                            onClick={(): void => {
                              this.onTabClick(dataSet.id);
                            }}
                          >
                            <i
                              className={
                                dataSet.id === this.state.dataSetTabId ? 'fa fa-check-square-o' : 'fa fa-square-o'
                              }
                            />{' '}
                            {dataSet.label}
                          </li>
                        ))}
                      </ul>
                      <a
                        className="problem--dataSetDownloadLink"
                        href={`${this.props.problem.id}/data_sets/${this.state.dataSetTabId}`}
                      >
                        <i className="fa fa-download" /> {`${this.selectedDataSet().label}のダウンロード`}
                      </a>
                    </div>
                    <textarea
                      className="problem--answer"
                      name="answer"
                      placeholder={`このテキストボックスに解答（作成したプログラムにデータセットを入力して得られた実行結果）を貼り付けて、右下の提出ボタンを押してください。\n\n${
                        this.props.problem.dataSets.length >= 2 ? `データセットの種類を選択してから、` : ``
                      }入力となるデータをフォームの右上のリンクからダウンロードしてください。`}
                      value={this.selectedDataSet().answer}
                      rows={Math.max(6, Math.min(18, this.selectedDataSet().answer.split('\n').length))}
                      onChange={(e: React.ChangeEvent<HTMLTextAreaElement>): void => {
                        this.onAnswerChange(e);
                      }}
                    />
                  </div>
                  <div className="problem--submitWrapper">
                    <input className="problem--submit" type="submit" value={t('submit')} />
                  </div>
                </form>
              ) : (
                <p>解答を提出するためにはログインが必要です</p>
              )}
            </div>
          </div>
        </div>
      </div>
    );
  }
}
