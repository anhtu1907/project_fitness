import React, { useEffect, useState } from "react";
import { Grid } from "gridjs-react";
import { html } from "gridjs";
import "gridjs/dist/theme/mermaid.min.css";
import { PageBreadcrumb } from "../../components";
import config from "../../config";
import { Link } from "react-router-dom";
import { APICore } from "../../helpers/api/apiCore";
const BASE_URL = config.API_URL;

type Order = {
  id: number;
  orderDate: string;
  totalAmount: number;
  status: boolean;
  delivered: boolean;
  user: string; // userId
};

type User = {
  id: string;
  username: string;
};

const api = new APICore();

const Orders = () => {
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);
  const [userMap, setUserMap] = useState<{ [key: string]: string }>({});

  useEffect(() => {
    Promise.all([fetchOrders(), fetchUsers()])
      .then(([ordersData, usersData]) => {
        setOrders(ordersData);
        setUserMap(
          Object.fromEntries(usersData.map((u: User) => [u.id, u.username]))
        );
      })
      .finally(() => setLoading(false));
  }, []);

  const fetchOrders = async () => {
    const res = await api.get("/api/order");
    console.log("Orders Data:", res);
    return res.data.data || [];
  };

  const fetchUsers = async () => {
    const res = await api.get("/identity/user");
    return res.data.data?.content || [];
  };

  function toInputDate(v?: number | string) {
  if (!v) return "";
  const seconds = typeof v === "string" ? parseInt(v, 10) : v;
  const d = new Date(seconds * 1000); 
  return isNaN(d.getTime()) ? "" : d.toISOString().slice(0, 10);
}

  return (
    <>
      <PageBreadcrumb
        name="Orders"
        title="Orders"
        breadCrumbItems={["Fitmate", "Orders", "Order List"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header">
            <div className="flex justify-between items-center">
              <h4 className="card-title">Order List</h4>
              
            </div>
          </div>
          <div className="p-6">
            {loading ? (
              <div className="text-center py-8">Loading...</div>
            ) : (
              <Grid
                data={orders.map((o) => [
                  o.id,
                  toInputDate(o.orderDate),
                  o.totalAmount,
                  // Status button
                  html(
                    o.status
                      ? `<button class="px-3 py-1 rounded bg-green-600 text-white text-xs font-semibold">Completed</button>`
                      : `<button class="px-3 py-1 rounded bg-yellow-500 text-white text-xs font-semibold">Pending</button>`
                  ),
                  userMap[o.user] || o.user,
                  // Delivered button
                  html(
                    o.delivered
                      ? `<button class="px-3 py-1 rounded bg-green-600 text-white text-xs font-semibold">Delivered</button>`
                      : `<button class="px-3 py-1 rounded bg-red-600 text-white text-xs font-semibold">Not Delivered</button>`
                  ),
                  html(`
                    <span class="inline-flex" style="min-width:70px;max-width:140px;">
                      <a href="/admin/order/detail/${o.id}" class="me-2" title="Detail">
                        <i class="mgc_information_line text-lg"></i>
                      </a>
                    </span>
                  `),
                ])}
                columns={[
                  { name: "ID", width: "6%" },
                  { name: "Order Date", width: "14%" },
                  { name: "Total Amount", width: "10%" },
                  { name: "Status", width: "10%" },
                  { name: "User", width: "15%" },
                  { name: "Delivered", width: "15%" },
                  { name: "Action", width: "10%" },
                ]}
                pagination={{ enabled: true, limit: 5 }}
                search={true}
                sort={true}
              />
            )}
          </div>
        </div>
      </div>
    </>
  );
};

export default Orders;