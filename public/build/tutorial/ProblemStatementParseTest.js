var __extends = (this && this.__extends) || (function () {
    var extendStatics = Object.setPrototypeOf ||
        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
        function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
import * as React from 'react';
import MarkdownRender from 'contests/MarkdownRender';
var ProblemStatementParseTest = (function (_super) {
    __extends(ProblemStatementParseTest, _super);
    function ProblemStatementParseTest() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    ProblemStatementParseTest.prototype.render = function () {
        return (React.createElement("div", null,
            React.createElement(MarkdownRender, { text: '# This is a test header\n\nthis is a **test** *content*.' }),
            React.createElement(MarkdownRender, { text: '日本語もおｋ\n\n\n\n* One\n* Two\n* Three' }),
            React.createElement(MarkdownRender, { text: 'Rendering mathmatical notations like $1 \\leq a_n, b_n \\leq 10^{5}$ is supported by using Mathjax.' }),
            React.createElement(MarkdownRender, { text: '| T | A | B | L | E |\n|--|--|--|--|--|\n| hoge | piyo | fuga | a | a |\n| a | b | c | d | e |' })));
    };
    return ProblemStatementParseTest;
}(React.Component));
export default ProblemStatementParseTest;
//# sourceMappingURL=ProblemStatementParseTest.js.map