import DataSetObject from 'contests/DataSetObject';

interface ProblemObject {
  id: number;
  task: string;
  name: string;
  description: string;
  dataSets: [DataSetObject];
}

export default ProblemObject;
