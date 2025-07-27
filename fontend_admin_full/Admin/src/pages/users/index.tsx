import { Link } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import {
  fetchUsers,
  userStatistics,
  UserResponse,
  fetchUsersByKeyword,
  fetchUserStatistics,
  UserStatisticsResponse,
} from "./data";
import { useEffect, useState, useRef } from "react";

const PAGE_SIZE = 5;

const UserStatistic = () => {
  const [stats, setStats] = useState<UserStatisticsResponse | null>(null);

  useEffect(() => {
    fetchUserStatistics().then(setStats);
  }, []);

  if (!stats) return <div>Loading statistics...</div>;

  const statList = [
    {
      count: stats.totalUsers,
      icon: "mgc_formula_line",
      status: "Total",
      variant: "bg-primary/25 text-primary",
    },
    {
      count: stats.activeUsers,
      icon: "mgc_check_line",
      status: "Active",
      variant: "bg-green-100 text-green-500",
    },
    {
      count: stats.inactiveUsers,
      icon: "mgc_alarm_2_line",
      status: "Inactive",
      variant: "bg-yellow-100 text-yellow-500",
    },
    {
      count: stats.weeklyActiveUsers,
      icon: "mgc_calendar_line",
      status: "Active (7d)",
      variant: "bg-blue-100 text-blue-500",
    },
  ];

  return (
    <div className="grid lg:grid-cols-4 md:grid-cols-2 grid-cols-1 gap-6">
      {statList.map((user, idx) => (
        <div className="card" key={idx}>
          <div className="p-5">
            <div className="flex justify-between">
              <div
                className={`w-20 h-20 rounded-full inline-flex items-center justify-center ${user.variant}`}
              >
                <i className={`${user.icon} text-4xl`}></i>
              </div>
              <div className="text-right">
                <h3 className="text-gray-700 mt-1 text-2xl font-bold mb-5 dark:text-gray-300">
                  {user.count}
                </h3>
                <p className="text-gray-500 mb-1 truncate dark:text-gray-400">
                  {user.status} Users
                </p>
              </div>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
};

const ManageUsers = () => {
  const [users, setUsers] = useState<UserResponse[]>([]);
  const [loading, setLoading] = useState(true);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [search, setSearch] = useState("");
  const searchInput = useRef<HTMLInputElement>(null);

  useEffect(() => {
    setLoading(true);
    const fetch = search
      ? fetchUsersByKeyword(search, page, PAGE_SIZE)
      : fetchUsers(page, PAGE_SIZE);
    fetch
      .then((res) => {
        setUsers(res.content);
        setTotal(res.totalElements);
        setTotalPages(res.totalPages);
      })
      .catch(() => setUsers([]))
      .finally(() => setLoading(false));
  }, [page, search]);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    setPage(1);
    setSearch(searchInput.current?.value || "");
  };

  return (
    <div className="mt-6">
      <div className="card">
        <div className="flex flex-wrap justify-between items-center gap-2 p-6">
          <form className="flex gap-2" onSubmit={handleSearch}>
            <input
              ref={searchInput}
              type="text"
              placeholder="Search by name..."
              className="form-input px-3 py-2 text-sm"
              defaultValue={search}
            />
            <button
              type="submit"
              className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
            >
              <i className="mgc_search_line me-2"></i> Search
            </button>
          </form>
          <div className="flex flex-wrap gap-2">
            {/* <button
              type="button"
              className="btn bg-success/25 text-lg font-medium text-success hover:text-white hover:bg-success"
            >
              <i className="mgc_settings_3_line"></i>
            </button> */}
            {/* <button
              type="button"
              className="btn bg-dark/25 text-sm font-medium text-slate-900 dark:text-slate-200/70 hover:text-white hover:bg-dark/90"
            >
              Import
            </button>
            <button
              type="button"
              className="btn bg-dark/25 text-sm font-medium text-slate-900 dark:text-slate-200/70 hover:text-white hover:bg-dark/90"
            >
              Export
            </button> */}
          </div>
        </div>
        <div className="relative overflow-x-auto">
          {loading ? (
            <div className="p-6 text-center">Loading...</div>
          ) : (
            <table className="w-full divide-y divide-gray-300 dark:divide-gray-700">
              <thead className="bg-slate-300 bg-opacity-20 border-t dark:bg-slate-800 divide-gray-300 dark:border-gray-700">
                <tr>
                  <th
                    scope="col"
                    className="py-3.5 ps-4 pe-3 text-left text-sm font-semibold text-gray-900 dark:text-gray-200"
                  >
                    No
                  </th>
                  <th
                    scope="col"
                    className="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-200"
                  >
                    Username
                  </th>
                  <th
                    scope="col"
                    className="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-200"
                  >
                    Email
                  </th>
                  <th
                    scope="col"
                    className="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-200"
                  >
                    Full Name
                  </th>
                  <th
                    scope="col"
                    className="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-200"
                  >
                    Role
                  </th>
                  <th
                    scope="col"
                    className="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-200"
                  >
                    Phone
                  </th>
                  <th
                    scope="col"
                    className="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-200"
                  >
                    Address
                  </th>
                  <th
                    scope="col"
                    className="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-200"
                  >
                    DOB
                  </th>
                  <th
                    scope="col"
                    className="px-3 py-3.5 text-center text-sm font-semibold text-gray-900 dark:text-gray-200"
                  >
                    Action
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200 dark:divide-gray-700 ">
                {(users || []).map((user, idx) => (
                  <tr key={user.id}>
                    <td className="whitespace-nowrap py-4 ps-4 pe-3 text-sm font-medium text-gray-900 dark:text-gray-200">
                      <b>{PAGE_SIZE * (page - 1) + idx + 1}</b>
                    </td>
                    <td className="whitespace-nowrap py-4 pe-3 text-sm">
                      {user.username}
                    </td>
                    <td className="whitespace-nowrap py-4 pe-3 text-sm font-medium text-gray-900 dark:text-gray-200">
                      {user.email}
                    </td>
                    <td className="whitespace-nowrap py-4 pe-3 text-sm">
                      {user.firstName} {user.lastName}
                    </td>
                    <td className="whitespace-nowrap py-4 pe-3 text-sm">
                      {user.role?.role}
                    </td>
                    <td className="whitespace-nowrap py-4 pe-3 text-sm">
                      {user.phone}
                    </td>
                    <td className="whitespace-nowrap py-4 pe-3 text-sm">
                      {user.address}
                    </td>
                    <td className="whitespace-nowrap py-4 pe-3 text-sm">
                      {Array.isArray(user.dob) && user.dob.length === 3
                        ? `${user.dob[2]
                            .toString()
                            .padStart(2, "0")}/${user.dob[1]
                            .toString()
                            .padStart(2, "0")}/${user.dob[0]}`
                        : user.dob || ""}
                    </td>
                    <td className="whitespace-nowrap py-4 px-3 text-center text-sm font-medium">
                      <Link
                        to={`/admin/manage-users/edit/${user.id}`}
                        className="me-0.5 inline-block"
                        title="Edit"
                      >
                        <i className="mgc_edit_line text-lg"></i>
                      </Link>
                      <Link
                        to={`/admin/manage-users/detail/${user.id}`}
                        className="ms-0.5 inline-block"
                        title="Detail"
                      >
                        <i className="mgc_information_line text-xl"></i>
                      </Link>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
          {/* Pagination controls */}
          <div className="flex justify-end p-4">
            <div className="flex items-center border border-gray-300 rounded-xl overflow-hidden divide-x divide-gray-300 shadow-sm">
              <button
                className={`px-4 py-2 text-sm font-medium transition-colors duration-150 ${
                  page === 1
                    ? "bg-gray-100 text-gray-400 cursor-not-allowed"
                    : "bg-white hover:bg-gray-100 text-gray-700"
                } rounded-l-xl`}
                disabled={page === 1}
                onClick={() => setPage(page - 1)}
              >
                Previous
              </button>

              <span className="px-4 py-2 text-sm text-gray-700 whitespace-nowrap">
                Page <span className="font-semibold">{page}</span> /{" "}
                <span className="font-semibold">{totalPages || 1}</span>
              </span>

              <button
                className={`px-4 py-2 text-sm font-medium transition-colors duration-150 ${
                  page >= totalPages
                    ? "bg-gray-100 text-gray-400 cursor-not-allowed"
                    : "bg-white hover:bg-gray-100 text-gray-700"
                } rounded-r-xl`}
                disabled={page >= totalPages}
                onClick={() => setPage(page + 1)}
              >
                Next
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

const UsersApp = () => {
  return (
    <>
      <PageBreadcrumb
        title="Users"
        name="Users"
        breadCrumbItems={["Fitmate", "Apps", "Users"]}
      />
      <UserStatistic />
      <ManageUsers />
    </>
  );
};

export default UsersApp;
