import React, { useState } from "react";

const DatePicker = () => {
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [currentMonth, setCurrentMonth] = useState(new Date());

  const daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  const daysInMonth = new Date(
    currentMonth.getFullYear(),
    currentMonth.getMonth() + 1,
    0
  ).getDate();

  const firstDayOfMonth = new Date(
    currentMonth.getFullYear(),
    currentMonth.getMonth(),
    1
  ).getDay();

  const changeMonth = (direction) => {
    const newMonth = new Date(
      currentMonth.getFullYear(),
      currentMonth.getMonth() + direction,
      1
    );
    setCurrentMonth(newMonth);
  };

  const handleDateSelect = (day) => {
    const newDate = new Date(
      currentMonth.getFullYear(),
      currentMonth.getMonth(),
      day
    );
    setSelectedDate(newDate);
  };

  return (
    <div className="p-4 max-w-md mx-auto bg-white shadow-lg rounded-lg">
      {/* Header */}
      <div className="flex justify-between items-center mb-4">
        <button
          onClick={() => changeMonth(-1)}
          className="p-2 bg-gray-200 rounded hover:bg-gray-300"
        >
          &lt;
        </button>
        <h2 className="text-lg font-bold">
          {currentMonth.toLocaleString("default", { month: "long" })}{" "}
          {currentMonth.getFullYear()}
        </h2>
        <button
          onClick={() => changeMonth(1)}
          className="p-2 bg-gray-200 rounded hover:bg-gray-300"
        >
          &gt;
        </button>
      </div>

      {/* Days of Week */}
      <div className="grid grid-cols-7 text-center font-semibold text-gray-600">
        {daysOfWeek.map((day) => (
          <div key={day}>{day}</div>
        ))}
      </div>

      {/* Days */}
      <div className="grid grid-cols-7 text-center">
        {/* Empty spaces for previous month */}
        {Array(firstDayOfMonth)
          .fill(null)
          .map((_, index) => (
            <div key={`empty-${index}`} className="p-2"></div>
          ))}

        {/* Days of current month */}
        {Array.from({ length: daysInMonth }, (_, day) => day + 1).map(
          (day) => (
            <button
              key={day}
              onClick={() => handleDateSelect(day)}
              className={`p-2 rounded ${
                selectedDate.getDate() === day &&
                currentMonth.getMonth() === selectedDate.getMonth() &&
                currentMonth.getFullYear() === selectedDate.getFullYear()
                  ? "bg-blue-500 text-white"
                  : "hover:bg-gray-200"
              }`}
            >
              {day}
            </button>
          )
        )}
      </div>
    </div>
  );
};

export default DatePicker;
