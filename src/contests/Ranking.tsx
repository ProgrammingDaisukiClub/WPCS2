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
  public static defaultProps: Partial<RankingProps> = {
    contest: {
      id: 1,
      name: 'contest name',
      description: 'description',
      joined: true,
      startAt: new Date((+new Date) - 60 * 60 * 1000),
      endAt: new Date((+new Date) + 60 * 60 * 1000),
      problems: [1, 2, 3, 4].map((pid) => ({
        id: pid,
        dataSets: ['Small', 'Large'].map((label, did) => ({
          id: did + 1,
          label: label,
          maxScore: Math.floor(Math.random() * 1000),
        } as DataSetScoreObject)) as [ DataSetObject ],
      } as ProblemScoreObject)) as [ ProblemObject ],
    },
    users: Array(220).fill(0).map((v, i) => v + i).map((uid) => ({
      id: uid + 1,
      totalScore: 200,
      name: `user name ${uid + 1}`,
      problems: [1, 2, 3, 4].map((pid) => ({
        id: pid,
        dataSets: ['Small', 'Large'].map((label, did) => ({
          id: did + 1,
          label: label,
          solvedAt: new Date,
          score: Math.floor(Math.random() * 1000),
        } as DataSetScoreObject)) as [ DataSetScoreObject ],
      } as ProblemScoreObject)) as [ ProblemScoreObject ],
    } as UserScoreObject)) as [ UserScoreObject ],
  };

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
          <div className="ranking--header">Ranking</div>
          <div className="ranking--body">
            <table className="ranking--table">
              <thead>
                <tr>
                  <td className="ranking--tableOrderHeader">順位</td>
                  <td className="ranking--tableNameHeader">名前</td>
                  { this.props.contest.problems.map((problem: ProblemObject, index: number) => (
                    problem.dataSets.map((dataSet: DataSetObject) => (
                      <td key={ dataSet.id } className="ranking--tableScoreHeader">
                        { index + 1 }: { dataSet.label }
                      </td>
                    ))
                  ))}
                  <td className="ranking--tableTotalScoreHeader">総合得点</td>
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
