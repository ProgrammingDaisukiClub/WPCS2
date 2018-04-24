import * as React from 'react';
import ContestObject from 'contests/ContestObject';
import MarkdownRenderer from 'contests/MarkdownRenderer';

export interface ContestHomeProps {
  contest: ContestObject;
  join: () => void;
}

export default class ContestHome extends React.Component<ContestHomeProps, {}> {
  private onJoinButtonClick() {
    this.props.join();
  }

  private async fetchContestStatus(){
      const responseContestStatus: Response = await fetch(`/api/contests/${this.props.contest.id}/status`, {
        credentials: 'same-origin',
      });

      switch(responseContestStatus.status) {
        case 200:
          const json: any = await responseContestStatus.json();
          status = json.status
          break;

        case 404: throw new Error('404 not found');
        default: throw new Error('unexpected http status');
      }

      let isStatusInside: boolean = status == "inside";
      return isStatusInside;
  }

  // private async submitStatus(data: string){
  //   const responsePasswordValidation: Response = await fetch(`/api/contests/${this.props.contest.id}/validate`, {
  //     body: JSON.stringify(
  //       {
  //         'password': data
  //       }
  //     ),
  //     credentials: 'same-origin',
  //   });
  //
  //   switch(responsePasswordValidation.status){
  //     case 200:
  //       const json: any = await responsePasswordValidation.json();
  //       let validationResult: boolean = json.result == "ok";
  //       return validationResult;
  //
  //     case 404: throw new Error('404 not found');
  //     default: throw new Error('unexpected http status');
  //   }
  // }

  public render() {
    let hiddenPasswordForm: any = this.fetchContestStatus() ? {} : { display: "none" };

    return (
      <div className="contestHome">
        <div className="contestHome--inner">
          <h2 className="contestHome--header">{ this.props.contest.name }</h2>
          <div className="contestHome--body">
            { !this.props.contest.adminRole && this.props.contest.currentUserId && (!this.props.contest.joined && new Date() < this.props.contest.endAt) &&
              <div className="contestHome--registrationButtonWrapper">

                <form style={ hiddenPasswordForm }>
                  <input id='password' type='text'/>
                </form>

                <span className="contestHome--registrationButton" onClick={ this.onJoinButtonClick.bind(this) }>
                  { t('join') }
                </span>
              </div>
            }
            { !this.props.contest.currentUserId &&
              <div className="contestHome--registrationButtonWrapper">
                <a className="contestHome--registrationButton" href="/users/sign_up">{ t('join') }</a>
              </div>
            }
            <MarkdownRenderer text={ this.props.contest.description } />
          </div>
        </div>
      </div>
    );
  }
}
