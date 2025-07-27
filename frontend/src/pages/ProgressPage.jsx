import { useState } from "react";
import MBIChart from "../components/MBIChart";
import Modal from "../components/ui/Modal";
import MainLayout from "../layouts/MainLayout";
import DatePicker from "../components/DatePicker";

function ProgressPage() {
  // handles Your Info Modal
  const [modalIsOpen, setModalIsOpen] = useState(false);
  const [height, setHeight] = useState("");
  const [weight, setWeight] = useState("");
  const [age, setAge] = useState("");
  const [history, setHistory] = useState([]);
  const [currentHeight, setCurrentHeight] = useState(0);
  const [currentWeight, setCurrentWeight] = useState(0);
  const [currentAge, setCurrentAge] = useState(0);
  const currentHeightParseToM = currentHeight / 100;
  const bmi = currentWeight / (currentHeightParseToM * currentHeightParseToM);
  const bodyfat = (1.20 * bmi) + (0.23 * currentAge) - 16.2;
  const smm = bmi * 0.407;
  const tbw = currentWeight * 0.6;
  const bmr =
    88.362 +
    13.397 * currentWeight +
    4.799 * currentHeight -
    5.677 * currentAge;
  const fatmass = currentWeight * (bodyfat / 100);
  let status = "";
  let color = "";

  if (bmi < 16) {
    status = "Severely underweight";
    color = "text-blue-700";
  } else if (bmi < 17) {
    status = "Moderately underweight";
    color = "text-blue-500";
  } else if (bmi < 18.5) {
    status = "Slightly underweight";
    color = "text-blue-400";
  } else if (bmi < 25) {
    status = "Normal";
    color = "text-green-600";
  } else if (bmi < 30) {
    status = "Overweight";
    color = "text-yellow-600";
  } else if (bmi < 35) {
    status = "Obese Class I";
    color = "text-orange-600";
  } else if (bmi < 40) {
    status = "Obese Class II";
    color = "text-red-600";
  } else {
    status = "Obese Class III";
    color = "text-red-800";
  }

  const openModal = () => setModalIsOpen(true);
  const closeModal = () => setModalIsOpen(false);


  const handleSubmit = (e) => {
    e.preventDefault();
    if (!height || !weight || !age) return;

    const today = new Date().toISOString().split("T")[0]; // YYYY-MM-DD
    const newEntry = {
      date: today,
      height: parseFloat(height),
      weight: parseFloat(weight),
    };

    // Cập nhật lịch sử
    setHistory([newEntry, ...history]);
    setCurrentHeight(parseFloat(height));
    setCurrentWeight(parseFloat(weight));
    setCurrentAge(parseInt(age));
    setHeight("");
    setWeight("");
    setAge("");
    closeModal();
  };

  const formInfo = (
    <div className="bg-white rounded-2xl shadow-lg p-6 max-w-3xl mx-auto">
      {/* Form update */}
      <div>
        <h3 className="text-2xl text-center text-sky-800 font-bold mb-4">Update New Info</h3>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700">Height (m)</label>
            <input
              type="number"
              step="0.01"
              value={height}
              onChange={(e) => setHeight(e.target.value)}
              className="mt-1 block w-full p-2 border border-gray-300 rounded-lg"
              placeholder="Enter your height"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700">Weight (kg)</label>
            <input
              type="number"
              step="0.1"
              value={weight}
              onChange={(e) => setWeight(e.target.value)}
              className="mt-1 block w-full p-2 border border-gray-300 rounded-lg"
              placeholder="Enter your weight"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700">Age</label>
            <input
              type="number"
              min={0}
              value={age}
              onChange={(e) => setAge(e.target.value)}
              className="mt-1 block w-full p-2 border border-gray-300 rounded-lg"
              placeholder="Enter your age"
            />
          </div>
          <button
            type="submit"
            className="w-full bg-blue-500 text-white py-2 px-4 rounded-lg hover:bg-blue-600"
          >
            Save Changes
          </button>
        </form>
      </div>

      {/* History table */}
      <div className="mt-8">
        <div className="text-lg text-gray-700 mb-2 font-semibold">History</div>
        <table className="w-full text-sm text-left text-gray-700 border">
          <thead className="text-xs uppercase bg-gray-100">
            <tr>
              <th className="px-6 py-3">Date</th>
              <th className="px-6 py-3">Height (cm)</th>
              <th className="px-6 py-3">Weight (kg)</th>
            </tr>
          </thead>
          <tbody>
            {history.map((entry, index) => (
              <tr key={index} className="border-t">
                <td className="px-6 py-2">{entry.date}</td>
                <td className="px-6 py-2">{entry.height.toFixed(2)}</td>
                <td className="px-6 py-2">{entry.weight.toFixed(1)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
  return (
    <MainLayout>
      {/* Modal for updating user info */}
      <Modal
        isOpen={modalIsOpen}
        onClose={closeModal}
        children={formInfo}
      />

      <section id="mbi">
        <div className="flex justify-evenly space-y-3 md:space-x-4 md:flex-row mt-4 p-2">
          {/* Right Side */}
          <div id="table-right">
            <div className="my-4 p-4 border border-sky-500 shadow rounded-2xl">
              <ul className="list-none text-xl text-gray-700">
                <li>Height:  {currentHeight.toFixed(1)} cm</li>
                <li>Weight:  {currentWeight.toFixed(1)} kg</li>
              </ul>
              <button
                onClick={openModal}
                className="mt-1 center rounded-lg bg-blue-500 text-white py-3 px-6 font-sans text-xs font-bold hover:bg-amber-800 hover:text-white"
              >
                Update New
              </button>
            </div>
            <h3 className="p-2 text-2xl text-center text-sky-800 font-bold">
              Your MBIs
            </h3>
            <table className="w-full text-left table-auto min-w-max overflow-scroll text-slate-300 bg-slate-800 shadow-md rounded-lg bg-clip-border">
              <thead>
                <tr>
                  <th className="p-4 border-b border-slate-600 bg-slate-700">
                    <p className="text-sm font-normal leading-none text-slate-300">
                      Type
                    </p>
                  </th>
                  <th className="p-4 border-b border-slate-600 bg-slate-700">
                    <p className="text-sm font-normal leading-none text-slate-300">
                      Value
                    </p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr className="even:bg-slate-900 hover:bg-slate-700">
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-100 font-semibold">
                      Body Fat
                    </p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">{bodyfat.toFixed(2)} %</p>
                  </td>
                </tr>
                <tr className="even:bg-slate-900 hover:bg-slate-700">
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-100 font-semibold">SMM</p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">{smm.toFixed(2)} Kg</p>
                  </td>
                </tr>
                <tr className="even:bg-slate-900 hover:bg-slate-700">
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-100 font-semibold">TBW</p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">{tbw.toFixed(2)} L</p>
                  </td>
                </tr>
                <tr className="even:bg-slate-900 hover:bg-slate-700">
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-100 font-semibold">
                      BMR
                    </p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">{bmr.toFixed(0)} kcal</p>
                  </td>
                </tr>

                <tr className="even:bg-slate-900 hover:bg-slate-700">
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-100 font-semibold">
                      Fat Mass
                    </p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">{fatmass.toFixed(2)} Kg</p>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          {/* Center */}
          <div id="statistic">
            <div className={`p-4 text-center text-4xl font-bold ${color}`}>
              You are <i>{status}</i>
            </div>
            <div>
              <MBIChart
                bodyFat={bodyfat}
                smm={smm}
                tbw={tbw}
                bmr={bmr}
                fatMass={fatmass}
              />
            </div>

          </div>
          {/* Left Side */}
          <div id="table-left">
            <div className="p-2 text-2xl text-center text-sky-800 font-bold">
              Standard MBIs
            </div>
            <table className="w-full text-left table-auto min-w-max overflow-scroll text-slate-300 bg-slate-800 shadow-md rounded-lg bg-clip-border">
              <thead>
                <tr>
                  <th className="p-4 border-b border-slate-600 bg-slate-700">
                    <p className="text-sm font-normal leading-none text-slate-300">
                      Type
                    </p>
                  </th>
                  <th className="p-4 border-b border-slate-600 bg-slate-700">
                    <p className="text-sm font-normal leading-none text-slate-300">
                      Male (%)
                    </p>
                  </th>
                  <th className="p-4 border-b border-slate-600 bg-slate-700">
                    <p className="text-sm font-normal leading-none text-slate-300">
                      Female (%)
                    </p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr className="even:bg-slate-900 hover:bg-slate-700">
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-100 font-semibold">
                      Essential Fat
                    </p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">2 - 5%</p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">10 - 13%</p>
                  </td>
                </tr>
                <tr className="even:bg-slate-900 hover:bg-slate-700">
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-100 font-semibold">
                      Athletes
                    </p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">6 - 13%</p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">14 - 20%</p>
                  </td>
                </tr>
                <tr className="even:bg-slate-900 hover:bg-slate-700">
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-100 font-semibold">
                      Fitness
                    </p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">14 - 17%</p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">21 - 24%</p>
                  </td>
                </tr>
                <tr className="even:bg-slate-900 hover:bg-slate-700">
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-100 font-semibold">
                      Normal
                    </p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">18 - 24%</p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">25 - 31%</p>
                  </td>
                </tr>
                <tr className="even:bg-slate-900 hover:bg-slate-700">
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-100 font-semibold">
                      Overweight
                    </p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">25 - 30%</p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">32 - 38%</p>
                  </td>
                </tr>
                <tr className="even:bg-slate-900 hover:bg-slate-700">
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-100 font-semibold">
                      Obese
                    </p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">31 - 35%</p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">39 - 43%</p>
                  </td>
                </tr>
                <tr className="even:bg-slate-900 hover:bg-slate-700">
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-100 font-semibold">
                      Obese II
                    </p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">&ge;36%</p>
                  </td>
                  <td className="p-4 border-b border-slate-700">
                    <p className="text-sm text-slate-300">&ge;44%</p>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>

    </MainLayout>
  );
}

export default ProgressPage;