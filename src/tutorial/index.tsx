import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { browserHistory, IndexRoute, Route, Router } from 'react-router';

import App from 'tutorial/App';
import ContestHome from 'tutorial/ContestHome';
import Problem from 'tutorial/Problem';
import ProblemStatementParseTest from 'tutorial/ProblemStatementParseTest';
import Ranking from 'tutorial/Ranking';

ReactDOM.render(
  <Router history={ browserHistory }>
    <Route path='react_tutorial' component={ App }>
      <IndexRoute component={ ContestHome } />
      <Route path='problems/:problemId' component={ Problem } />
      <Route path='ranking' component={ Ranking } />
      <Route path='statement_test' component={ ProblemStatementParseTest } />
    </Route>
  </Router>,
  document.getElementById('app')
);
