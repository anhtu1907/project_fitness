import { Link } from "react-router-dom";

function WorkoutCard() {
  return (
    <div className="flex justify-center">
      <div className="each mb-10 m-2 shadow-lg border-gray-800 bg-gray-100 relative">
        <img
          className="w-full"
          src="https://i.ytimg.com/vi/qew27BNl7io/maxresdefault.jpg"
          alt=""
        />
        <div className="badge absolute top-0 right-0 bg-indigo-500 m-1 text-gray-200 p-1 px-2 text-xs font-bold rounded">
          10:53
        </div>
        <div className="text-xs flex p-1 font-semibold text-gray-500 bg-gray-300">
          <span className="mr-1 p-1 px-2 font-bold">105 views</span>
          <span className="mr-1 p-1 px-2 font-bold border-l border-gray-400">
            Arms
          </span>
          <span className="mr-1 p-1 px-2 font-bold border-l border-gray-400">
            Beginner
          </span>
        </div>
        <div className="p-4 text-gray-800">
          <a
            href="https://www.youtube.com/watch?v=dvqT-E74Qlo"
            target="_new"
            className="title font-bold block cursor-pointer hover:underline"
          >
            How to make your arms bigger in 10 minutes
          </a>
          <a
            href="https://www.youtube.com/user/sam14319"
            target="_new"
            className="badge bg-indigo-500 text-blue-100 rounded px-1 text-xs font-bold cursor-pointer"
          >
            @duynguyen17
          </a>
          <span className="description text-sm block py-2 border-gray-400 mb-2">
            This is a short workout video that focuses on arm exercises to help
            you build muscle and strength in just 10 minutes.
          </span>
        </div>
        <div className="p-4 flex justify-between items-center">
          <button className="bg-cyan-500 text-white px-4 py-2 rounded hover:bg-indigo-600">Add to Progress</button>
          <Link to="/workout/1" className="bg-rose-600 text-white px-4 py-2 rounded hover:bg-indigo-600">
            Watch Now
          </Link>
        </div>
      </div>
    </div>
  );
}

export default WorkoutCard;
