import { Link } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { useEffect, useRef, useState } from "react";
import { UserResponse, fetchInactiveUsers } from "./data";

const PAGE_SIZE = 5;

const InactiveUsers = () => {
  const [users, setUsers] = useState<UserResponse[]>([]);
  const [loading, setLoading] = useState(true);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  useEffect(() => {
    setLoading(true);
    fetchInactiveUsers(page, PAGE_SIZE)
      .then((res) => {
        setUsers(res.content);
        setTotal(res.totalElements);
        setTotalPages(res.totalPages);
      })
      .catch(() => setUsers([]))
      .finally(() => setLoading(false));
  }, [page]);

  return (
    <>
      <PageBreadcrumb
        title="Inactive Users"
        name="Inactive Users"
        breadCrumbItems={["Fitmate", "Users", "Inactive"]}
      />
      <div className="mt-6">
        <div className="card">
          <div className="flex justify-between items-center gap-2 p-6">
            <h2 className="text-xl font-semibold">Inactive Users</h2>
          </div>
          <div className="relative overflow-x-auto">
            {loading ? (
              <div className="p-6 text-center">Loading...</div>
            ) : (
              <table className="w-full divide-y divide-gray-300 dark:divide-gray-700">
                <thead className="bg-slate-300 bg-opacity-20 border-t dark:bg-slate-800 divide-gray-300 dark:border-gray-700">
                  <tr>
                    <th className="py-3 px-4 text-left text-sm font-semibold">
                      No
                    </th>
                    <th className="px-3 py-3 text-left text-sm font-semibold">
                      Username
                    </th>
                    <th className="px-3 py-3 text-left text-sm font-semibold">
                      Email
                    </th>
                    <th className="px-3 py-3 text-left text-sm font-semibold">
                      Full Name
                    </th>
                    <th className="px-3 py-3 text-left text-sm font-semibold">
                      Role
                    </th>
                    <th className="px-3 py-3 text-left text-sm font-semibold">
                      Phone
                    </th>
                    <th className="px-3 py-3 text-left text-sm font-semibold">
                      Address
                    </th>
                    <th className="px-3 py-3 text-left text-sm font-semibold">
                      DOB
                    </th>
                    <th className="px-3 py-3 text-center text-sm font-semibold">
                      Action
                    </th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
                  {users.map((user, idx) => (
                    <tr key={user.id}>
                      <td className="whitespace-nowrap py-4 px-4 text-sm font-medium">
                        {PAGE_SIZE * (page - 1) + idx + 1}
                      </td>
                      <td className="whitespace-nowrap px-3 py-4 text-sm">
                        {user.username}
                      </td>
                      <td className="whitespace-nowrap px-3 py-4 text-sm">
                        {user.email}
                      </td>
                      <td className="whitespace-nowrap px-3 py-4 text-sm">
                        {user.firstName} {user.lastName}
                      </td>
                      <td className="whitespace-nowrap px-3 py-4 text-sm">
                        {user.role?.role}
                      </td>
                      <td className="whitespace-nowrap px-3 py-4 text-sm">
                        {user.phone}
                      </td>
                      <td className="whitespace-nowrap px-3 py-4 text-sm">
                        {user.address}
                      </td>
                      <td className="whitespace-nowrap px-3 py-4 text-sm">
                        {Array.isArray(user.dob) && user.dob.length === 3
                          ? `${user.dob[2]
                              .toString()
                              .padStart(2, "0")}/${user.dob[1]
                              .toString()
                              .padStart(2, "0")}/${user.dob[0]}`
                          : user.dob || ""}
                      </td>
                      <td className="whitespace-nowrap px-3 py-4 text-center text-sm">
                        <Link to={`/admin/manage-users/edit/${user.id}`} title="Edit">
                          <i className="mgc_edit_line text-lg me-2"></i>
                        </Link>
                        <Link
                          to={`/admin/manage-users/detail/${user.id}`}
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
            {/* Pagination */}
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
    </>
  );
};

export default InactiveUsers;
