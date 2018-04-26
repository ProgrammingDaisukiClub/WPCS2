import DataSetScoreObject from 'contests/DataSetScoreObject';

interface ProblemScoreObject {
  id: number;
  dataSets: [DataSetScoreObject];
}

export default ProblemScoreObject;
