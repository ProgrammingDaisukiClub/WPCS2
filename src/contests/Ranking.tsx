import * as React from 'react';

import ContestObject from 'contests/ContestObject';
import ProblemObject from 'contests/ProblemObject';
import DataSetObject from 'contests/DataSetObject';
import UserScoreObject from 'contests/UserScoreObject';
import ProblemScoreObject from 'contests/ProblemScoreObject';
import DataSetScoreObject from 'contests/DataSetScoreObject';

interface RankingProps {
  contest: ContestObject;
  users: [ UserScoreObject ];
}

interface RankingState {
  currentPage: number;
}

export default class Ranking extends React.Component<RankingProps, RankingState> {
  constructor() {
    super();

    this.state = {
      currentPage: 1
    };
  }

  public onPaginationClick(nextPage: number) {
    this.setState({
      currentPage: nextPage
    })
  }

  public passedTime(startAt: Date, solvedAt: Date): string {
    const diff: number = Math.floor(((+solvedAt) - (+startAt)) / 1000);
    const minutes: number = Math.floor(diff / 60);
    const seconds: number = diff % 60;
    return `${minutes < 10 ? '0' : ''}${minutes}:${seconds < 10 ? '0' : ''}${seconds}`;
  }

  public render() {
    const usersPerPage = 50;
    const pageOffset: number = (this.state.currentPage - 1) * usersPerPage;
    const pageLength: number = Math.ceil(this.props.users.length / usersPerPage);

    return (
      <div className="ranking">
        <div className="ranking--inner">
          <div className="ranking--header">{ t('ranking') }</div>
          <div className="ranking--body">
            <table className="ranking--table">
              <thead>
                <tr>
                  <td className="ranking--tableOrderHeader">{ t('rank') }</td>
                  <td className="ranking--tableNameHeader">{ t('user_name') }</td>
                  { this.props.contest.problems.map((problem: ProblemObject, index: number) => (
                    problem.dataSets.map((dataSet: DataSetObject) => (
                      <td key={ dataSet.id } className="ranking--tableScoreHeader">
                        { index + 1 }: { dataSet.label }
                      </td>
                    ))
                  ))}
                  <td className="ranking--tableTotalScoreHeader">{ t('total_score') }</td>
                </tr>
              </thead>
              <tbody>
                { this.props.users.slice(pageOffset, pageOffset + usersPerPage).map((user: UserScoreObject, index: number) => (
                  <tr key={ user.id }>
                    <td className="ranking--tableOrder">{ pageOffset + index + 1 }</td>
                    <td className="ranking--tableName">{ user.name }</td>
                    { user.problems.map((problem: ProblemScoreObject) => (
                      problem.dataSets.map((dataSet: DataSetScoreObject) => (
                        <td key={ dataSet.id } className="ranking--tableScore">
                          <div className="ranking--score">
                            { dataSet.score ? dataSet.score : '-' }
                          </div>
                          <div className="ranking--solvedTime">
                            { dataSet.solvedAt ?
                              this.passedTime(this.props.contest.startAt, dataSet.solvedAt) : '--:--'
                            }
                          </div>
                        </td>
                      ))
                    )) }
                    <td className="ranking--tableTotalScore">{ user.totalScore }</td>
                  </tr>
                )) }
              </tbody>
            </table>
            <ul>
              { Array(pageLength).fill(0).map((v, i) => v + i + 1).map((page) => (
                <li key={ page } className="ranking--pagination" onClick={ () => this.onPaginationClick(page) }>
                  { page }
                </li>
              )) }
            </ul>
          </div>
        </div>
      </div>
    );
  }
}
