import * as React from 'react';

import ContestObject from 'contests/ContestObject';
import DataSetScoreObject from 'contests/DataSetScoreObject';
import ProblemObject from 'contests/ProblemObject';
import ProblemScoreObject from 'contests/ProblemScoreObject';
import UserScoreObject from 'contests/UserScoreObject';

interface RankingProps {
  contest: ContestObject;
  users: UserScoreObject[];
}

interface RankingState {
  currentPage: number;
}

export default class Ranking extends React.Component<RankingProps, RankingState> {
  constructor() {
    super();

    this.state = {
      currentPage: 1,
    };
  }

  public onPaginationClick(nextPage: number): void {
    this.setState({
      currentPage: nextPage,
    });
  }

  public passedTime(startAt: Date, solvedAt: Date): string {
    const diff: number = Math.floor((+solvedAt - +startAt) / 1000);
    const minutes: number = Math.floor(diff / 60);
    const seconds: number = diff % 60;

    return `${minutes < 10 ? '0' : ''}${minutes}:${seconds < 10 ? '0' : ''}${seconds}`;
  }

  public render(): JSX.Element {
    const usersPerPage: number = 50;
    const pageOffset: number = (this.state.currentPage - 1) * usersPerPage;
    const pageLength: number = Math.ceil(this.props.users.length / usersPerPage);

    return (
      <div className="ranking">
        <div className="ranking--inner">
          <div className="ranking--header">{t('ranking')}</div>
          <div className="ranking--body">
            <table className="ranking--table">
              <thead>
                <tr>
                  <td className="ranking--tableOrderHeader">{t('rank')}</td>
                  <td className="ranking--tableNameHeader">{t('user_name')}</td>
                  {this.props.contest.problems.map((problem: ProblemObject) => (
                    <td key={problem.id} className="ranking--tableScoreHeader">
                      {problem.task}
                    </td>
                  ))}
                  <td className="ranking--tableTotalScoreHeader">{t('total_score')}</td>
                </tr>
              </thead>
              <tbody>
                {this.props.users
                  .slice(pageOffset, pageOffset + usersPerPage)
                  .map((user: UserScoreObject, index: number) => (
                    <tr
                      className={`ranking--tableRow${user.id === this.props.contest.currentUserId ? '__self' : ''}`}
                      key={user.id}
                    >
                      <td className="ranking--tableOrder">{pageOffset + index + 1}</td>
                      <td className="ranking--tableName">
                        <a href={`/users/${user.id}`}>{user.name}</a>
                      </td>
                      {user.problems.map((problem: ProblemScoreObject) => (
                        <td key={problem.id} className="ranking--tableScore">
                          {problem.dataSets.map(
                            (dataSet: DataSetScoreObject) =>
                              dataSet.correct ? (
                                <div key={dataSet.id} className="ranking--dataSet">
                                  <div className="ranking--score">
                                    {dataSet.score}
                                    {dataSet.wrongAnswers > 0 ? (
                                      <span className="ranking--score__wrong"> ({dataSet.wrongAnswers})</span>
                                    ) : (
                                      ''
                                    )}
                                  </div>
                                  <div className="ranking--solvedAt">
                                    {this.passedTime(this.props.contest.startAt, dataSet.solvedAt)}
                                  </div>
                                </div>
                              ) : dataSet.wrongAnswers > 0 ? (
                                <div key={dataSet.id} className="ranking--dataSet">
                                  <div className="ranking--score__wrong">({dataSet.wrongAnswers})</div>
                                  <div className="ranking--solvedAt">--:--</div>
                                </div>
                              ) : (
                                <div key={dataSet.id} className="ranking--dataSet">
                                  <div className="ranking--score">-</div>
                                  <div className="ranking--solvedAt">--:--</div>
                                </div>
                              )
                          )}
                        </td>
                      ))}
                      <td className="ranking--tableTotalScore">{user.totalScore}</td>
                    </tr>
                  ))}
              </tbody>
            </table>
            <ul>
              {Array(pageLength)
                .fill(0)
                .map((v: number, i: number) => v + i + 1)
                .map((page: any) => (
                  <li
                    role="button"
                    key={page}
                    className="ranking--pagination"
                    onClick={(): void => {
                      this.onPaginationClick(page);
                    }}
                  >
                    {page}
                  </li>
                ))}
            </ul>
          </div>
        </div>
      </div>
    );
  }
}
