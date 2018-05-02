import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { browserHistory, IndexRoute, Route, Router } from 'react-router';
import 'whatwg-fetch';

import ContestApp from 'contests/ContestApp';
import ContestHome from 'contests/ContestHome';
import Editorial from 'contests/Editorial';
import Problem from 'contests/Problem';
import Ranking from 'contests/Ranking';
import Submissions from 'contests/Submissions';

ReactDOM.render(
  <Router history={browserHistory}>
    <Route path="contests/:contestId" component={ContestApp}>
      <IndexRoute component={ContestHome} />
      <Route path="problems/:problemId" component={Problem} />
      <Route path="ranking" component={Ranking} />
      <Route path="submissions" component={Submissions} />
      <Route path="editorials/:editorialId" component={Editorial} />
    </Route>
  </Router>,
  document.getElementById('contests-app')
);
