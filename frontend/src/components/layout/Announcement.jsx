import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import useDealStore from "../../stores/useDealsStore";

function Announcement({ autoPlay = true, interval = 2000 }) {
  const { deals } = useDealStore();

  const [currentIndex, setCurrentIndex] = useState(0);

  const handleNext = () => {
    setCurrentIndex((prevIndex) => (prevIndex + 1) % deals.length);
  };

  const handlePrev = () => {
    setCurrentIndex((prevIndex) =>
      prevIndex === 0 ? deals.length - 1 : prevIndex - 1
    );
  };

  useEffect(() => {
    if (autoPlay) {
      const autoSlide = setInterval(handleNext, interval);
      return () => clearInterval(autoSlide);
    }
  }, [currentIndex, interval, autoPlay]);

  return (
    <div className="flex justify-center gap-8 py-2 bg-sky-300">
      <button onClick={handlePrev}>
        <FontAwesomeIcon icon={["fas", "angles-left"]} color="white" />
      </button>
      <div className="deals">
        <Link to={deals[currentIndex].link} className="text-yellow-800">
          {deals[currentIndex].title}
        </Link>
      </div>
      <button onClick={handleNext}>
        <FontAwesomeIcon icon={["fas", "angles-right"]} color="white" />
      </button>
    </div>
  );
}

export default Announcement;
