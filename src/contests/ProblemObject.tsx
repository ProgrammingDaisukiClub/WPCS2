import DataSetObject from 'contests/DataSetObject'

interface ProblemObject {
  id: number;
  name: string;
  description: string;
  dataSets: [DataSetObject];
}

export default ProblemObject;
