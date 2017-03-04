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
import * as marked from 'marked';
import * as React from 'react';
import * as renderHTML from 'react-render-html';
var MarkdownRender = (function (_super) {
    __extends(MarkdownRender, _super);
    function MarkdownRender() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    MarkdownRender.prototype.componentDidMount = function () {
        MathJax.Hub.Queue(['Typeset', MathJax.Hub]);
    };
    MarkdownRender.prototype.render = function () {
        return (React.createElement("div", { className: 'markdown-body' }, renderHTML(marked(this.props.text))));
    };
    return MarkdownRender;
}(React.Component));
export default MarkdownRender;
//# sourceMappingURL=MarkdownRender.js.map