import React, { useEffect, useState } from "react";
import { Grid } from "gridjs-react";
import { html } from "gridjs";
import "gridjs/dist/theme/mermaid.min.css";
import { PageBreadcrumb } from "../../components";
import config from "../../config";
import { Link } from "react-router-dom";
import { APICore } from "../../helpers/api/apiCore";
const BASE_URL = config.API_URL;
const IMAGE_BASE_URL = BASE_URL + "/resources/";

const api = new APICore();

const Equipments = () => {
  const [equipments, setEquipments] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchEquipments()
      .then(setEquipments)
      .finally(() => setLoading(false));
  }, []);

  const fetchEquipments = async () => {
    const res = await api.get("/api/admin/equipment");
    return res.data.data || [];
  };

  return (
    <>
      <PageBreadcrumb
        name="Equipments"
        title="Equipments"
        breadCrumbItems={["Fitmate", "Equipments", "List"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header">
            <div className="flex justify-between items-center">
              <h4 className="card-title">Equipment List</h4>
              <Link
                to="/admin/exercise/equipment/add"
                className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
              >
                <i className="mgc_add_circle_line me-2"></i> Add New Equipment
              </Link>
            </div>
          </div>
          <div className="p-6">
            {loading ? (
              <div className="text-center py-8">Loading...</div>
            ) : (
              <Grid
                data={equipments.map((e) => [
                  e.id,
                  e.equipmentImage
                    ? /\.(jpg|jpeg|png|webp|gif)$/i.test(e.equipmentImage)
                                          ? html(
                                            `<img src="${e.equipmentImage.startsWith("http")
                                              ? e.equipmentImage
                                              : IMAGE_BASE_URL + e.equipmentImage
                                            }" alt="${e.equipmentImage}" 
                              style="width:80px;height:80px;object-fit:cover;border-radius:8px;" />`
                                          )
                                          : html(
                                            `<a href="${e.equipmentImage}" target="_blank" style="color:blue;text-decoration:underline;">
                              ${e.equipmentImage}
                            </a>`
                                          )
                                        : "",
                  e.equipmentName,
                  html(`
      <span class="inline-flex" style="min-width:70px;max-width:140px;">
        <a href="/admin/exercise/equipment/edit/${e.id}" class="me-2" title="Edit">
          <i class="mgc_edit_line text-lg"></i>
        </a>     
      </span>
    `),
                ])}
                columns={[
                  { name: "ID", width: "6%" },
                  { name: "Image", width: "12%" },
                  "Name",
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

export default Equipments;