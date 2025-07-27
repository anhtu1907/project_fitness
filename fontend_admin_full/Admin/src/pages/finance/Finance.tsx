import React, { useEffect, useState } from "react";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";

const api = new APICore();

const Finance = () => {
  const [stats, setStats] = useState<any>(null);
  const [dailyStats, setDailyStats] = useState<any>(null);
  const [yearlyStats, setYearlyStats] = useState<any>(null);
  const [payments, setPayments] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const now = new Date();
    const year = now.getFullYear();
    const month = now.getMonth() + 1;
    const day = now.toISOString().split("T")[0];

    Promise.all([
      api.get(`/api/finance/orders/month?year=${year}&month=${month}`),
      api.get(`/api/finance/sales/day?date=${day}`),
      api.get(`/api/finance/sales/year?year=${year}`),
      api.get(`/api/payment`),
    ])
      .then(([monthlyRes, dailyRes, yearlyRes, paymentRes]) => {
        setStats(monthlyRes.data);
        setDailyStats(dailyRes.data);
        setYearlyStats(yearlyRes.data);
        setPayments(paymentRes.data.data || []);
        console.log("Finance data loaded successfully", {
          monthly: monthlyRes.data,
          daily: dailyRes.data,
          yearly: yearlyRes.data,
          payments: paymentRes.data.data,
        });
      })
      .finally(() => setLoading(false));
  }, []);

  return (
    <>
      <PageBreadcrumb
        title="Finance"
        name="Finance"
        breadCrumbItems={["Fitmate", "Finance"]}
      />
      <div className="mt-6">
        {loading ? (
          <div className="text-center py-10">Loading...</div>
        ) : (
          <>
            {/* Tổng quan doanh thu tháng */}
            <div className="card mb-6">
              <div className="p-6">
                <h4 className="font-bold mb-2">Monthly Overview</h4>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
                  <div>
                    <div className="text-gray-500 text-sm">Order Count</div>
                    <div className="text-xl font-bold">{stats?.orderCount ?? 0}</div>
                  </div>
                  <div>
                    <div className="text-gray-500 text-sm">Total Sales</div>
                    <div className="text-xl font-bold">{stats?.totalSales?.toLocaleString()} $</div>
                  </div>
                </div>
              </div>
            </div>

            {/* Tổng quan doanh thu ngày */}
            <div className="card mb-6">
              <div className="p-6">
                <h4 className="font-bold mb-2">Daily Overview</h4>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
                  <div>
                    <div className="text-gray-500 text-sm">Order Count</div>
                    <div className="text-xl font-bold">{dailyStats?.orderCount ?? 0}</div>
                  </div>
                  <div>
                    <div className="text-gray-500 text-sm">Total Sales</div>
                    <div className="text-xl font-bold">{dailyStats?.totalSales?.toLocaleString()} $</div>
                  </div>
                </div>
              </div>
            </div>

            {/* Tổng quan doanh thu năm */}
            <div className="card mb-6">
              <div className="p-6">
                <h4 className="font-bold mb-2">Yearly Overview</h4>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
                  <div>
                    <div className="text-gray-500 text-sm">Order Count</div>
                    <div className="text-xl font-bold">{yearlyStats?.orderCount ?? 0}</div>
                  </div>
                  <div>
                    <div className="text-gray-500 text-sm">Total Sales</div>
                    <div className="text-xl font-bold">{yearlyStats?.totalSales?.toLocaleString()} $</div>
                  </div>
                </div>
              </div>
            </div>

            {/* Top sản phẩm bán chạy */}
            <div className="card mb-6">
              <div className="p-6">
                <h4 className="font-bold mb-2">Top Selling Products</h4>
                <table className="min-w-full border">
                  <thead>
                    <tr className="bg-gray-100">
                      <th className="p-2 border">Product Name</th>
                      <th className="p-2 border">Quantity Sold</th>
                      <th className="p-2 border">Total Value</th>
                    </tr>
                  </thead>
                  <tbody>
                    {(stats?.topSellingProducts || []).map((prod: any) => (
                      <tr key={prod.productId}>
                        <td className="p-2 border">{prod.productName}</td>
                        <td className="p-2 border">{prod.quantitySold}</td>
                        <td className="p-2 border">{prod.totalValue?.toLocaleString()} $</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>

            {/* Top sản phẩm giá trị cao */}
            <div className="card mb-6">
              <div className="p-6">
                <h4 className="font-bold mb-2">Top Value Products</h4>
                <table className="min-w-full border">
                  <thead>
                    <tr className="bg-gray-100">
                      <th className="p-2 border">Product Name</th>
                      <th className="p-2 border">Quantity Sold</th>
                      <th className="p-2 border">Total Value</th>
                    </tr>
                  </thead>
                  <tbody>
                    {(stats?.topValueProducts || []).map((prod: any) => (
                      <tr key={prod.productId}>
                        <td className="p-2 border">{prod.productName}</td>
                        <td className="p-2 border">{prod.quantitySold}</td>
                        <td className="p-2 border">{prod.totalValue?.toLocaleString()} $</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>

            {/* Danh sách giao dịch thanh toán */}
            <div className="card mb-6">
              <div className="p-6">
                <h4 className="font-bold mb-2">Payment Transactions</h4>
                <table className="min-w-full border">
                  <thead>
                    <tr className="bg-gray-100">
                      <th className="p-2 border">ID</th>
                      <th className="p-2 border">Order</th>
                      <th className="p-2 border">Amount</th>
                      <th className="p-2 border">Currency</th>
                      <th className="p-2 border">Status</th>
                      <th className="p-2 border">Date</th>
                      <th className="p-2 border">Transaction Code</th>
                    </tr>
                  </thead>
                  <tbody>
                    {payments.length > 0 ? (
                      payments.map((pay: any) => (
                        <tr key={pay.id}>
                          <td className="p-2 border">{pay.id}</td>
                          <td className="p-2 border">{pay.order?.id ?? "-"}</td>
                          <td className="p-2 border">{pay.amount?.toLocaleString()} VND</td>
                          <td className="p-2 border">{pay.currency}</td>
                          <td className="p-2 border">
                            {pay.status ? (
                              <span className="text-green-600 font-semibold">Success</span>
                            ) : (
                              <span className="text-red-500 font-semibold">Failed</span>
                            )}
                          </td>
                          <td className="p-2 border">
                            {pay.paymentDate
                              ? new Date(pay.paymentDate).toLocaleString("vi-VN")
                              : "-"}
                          </td>
                          <td className="p-2 border">{pay.transactionCode}</td>
                        </tr>
                      ))
                    ) : (
                      <tr>
                        <td colSpan={7} className="p-2 border text-center text-gray-400">
                          No payments found
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          </>
        )}
      </div>
    </>
  );
};

export default Finance;