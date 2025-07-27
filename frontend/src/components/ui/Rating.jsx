import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

function Rating({ rating }) {
  let stars = [false, false, false, false, false];
  for (let i = 1; i <= 5; i++) {
    if (i <= rating) {
      stars[i - 1] = true;
    }
  }
  return (
    <>
      {/* Rate */}
      <div className="flex justify-between items-center space-x-2 py-2">
        {/* stars */}
        <div className="">
          {stars.map((s, index) => (
            <FontAwesomeIcon key={index} icon={["fas", "star"]} size="1x" className={s ? "text-yellow-300" : "text-gray-500"}/>
          ))}
        </div>
        {/* number */}
        <p className="ms-1 text-sm font-medium text-gray-500 dark:text-gray-400">
          {rating}&nbsp;out of&nbsp;5
        </p>
      </div>
    </>
  );
}

export default Rating;
