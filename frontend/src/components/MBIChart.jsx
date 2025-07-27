import {
  Radar,
  RadarChart,
  PolarGrid,
  PolarAngleAxis,
  PolarRadiusAxis,
} from "recharts";

function MBIChart({ bodyFat, smm, tbw, bmr, fatMass }) {
  const normalizedData = [
    { subject: "Body Fat", value: (bodyFat / 50) * 100 },
    { subject: "SMM", value: (smm / 20) * 100 },
    { subject: "TBW", value: (tbw / 50) * 100 },
    { subject: "BMR", value: (bmr / 2500) * 100 },
    { subject: "FatMass", value: (fatMass / 30) * 100 },
  ];

  return (
    <div className="p-4">
      <RadarChart outerRadius={150} width={500} height={500} data={normalizedData}>
        <PolarGrid />
        <PolarAngleAxis dataKey="subject" />
        <PolarRadiusAxis angle={30} domain={[0, 100]} />
        <Radar
          name="Your MBIs"
          dataKey="value"
          stroke="#4f46e5"
          fill="#6366f1"
          fillOpacity={0.6}
        />
      </RadarChart>
    </div>
  );
}

export default MBIChart;
