import React, { useEffect, useState } from "react";
import { Grid } from "gridjs-react";
import { html } from "gridjs";
import "gridjs/dist/theme/mermaid.min.css";
import { PageBreadcrumb } from "../../components";
import config from "../../config";
import { Link } from "react-router-dom";
import { APICore } from "../../helpers/api/apiCore";
import Swal from "sweetalert2";
import toast, { Toaster } from "react-hot-toast";

const BASE_URL = config.API_URL;
const IMAGE_BASE_URL = BASE_URL + "/resources/";

const api = new APICore();

// 👇 Khai báo cho TypeScript hiểu thuộc tính gán vào window
declare global {
  interface Window {
    handleDeleteExercise?: (id: number) => void;
  }
}

const Exercises = () => {
  const [exercises, setExercises] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [equipmentMap, setEquipmentMap] = useState<{ [key: number]: string }>({});
  const [modeMap, setModeMap] = useState<{ [key: number]: string }>({});
  const [subCategoryMap, setSubCategoryMap] = useState<{ [key: number]: string }>({});

  useEffect(() => {
    fetchExercises()
      .then(setExercises)
      .finally(() => setLoading(false));
  }, []);

  useEffect(() => {
    Promise.all([fetchEquipments(), fetchModes(), fetchSubCategories()]).then(
      ([equipments, modes, subcategories]) => {
        setEquipmentMap(
          Object.fromEntries(equipments.map((e: any) => [e.id, e.equipmentName]))
        );
        setModeMap(Object.fromEntries(modes.map((m: any) => [m.id, m.modeName])));
        setSubCategoryMap(
          Object.fromEntries(subcategories.map((s: any) => [s.id, s.subCategoryName]))
        );
      }
    );
  }, []);

  useEffect(() => {
  window.handleDeleteExercise = async (id: number) => {
    const result = await Swal.fire({
      title: "Are you sure?",
      text: "This exercise will be deleted permanently.",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#d33",
      cancelButtonColor: "#3085d6",
      confirmButtonText: "Yes, delete it!",
    });

    if (result.isConfirmed) {
      try {
        await api.delete(`/api/admin/exercises/${id}`);
        toast.success("Exercise deleted successfully");

        setExercises((prev) => prev.filter((e) => e.id !== id));
      } catch (err) {
        console.error("Delete failed", err);
        toast.error("Failed to delete exercise");
      }
    }
  };

  return () => {
    delete window.handleDeleteExercise;
  };
}, []);


  const fetchExercises = async () => {
    const res = await api.get("/api/admin/exercises");
    return res.data.data || [];
  };

  const fetchEquipments = async () => {
    const res = await api.get("/api/admin/equipment");
    return res.data.data || [];
  };

  const fetchModes = async () => {
    const res = await api.get("/api/admin/exercise-mode");
    return res.data.data || [];
  };

  const fetchSubCategories = async () => {
    const res = await api.get("/api/admin/exercise-sub-category");
    return res.data.data || [];
  };

  return (
    <>
      <Toaster position="top-right" reverseOrder={false} />
      <PageBreadcrumb
        name="Exercises"
        title="Exercises"
        breadCrumbItems={["Fitmate", "Exercises", "List"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header">
            <div className="flex justify-between items-center">
              <h4 className="card-title">Exercise List</h4>
              <Link
                to="/admin/exercise/exercise/add"
                className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
              >
                <i className="mgc_add_circle_line me-2"></i> Add New Exercise
              </Link>
            </div>
          </div>
          <div className="p-6">
            {loading ? (
              <div className="text-center py-8">Loading...</div>
            ) : (
              <Grid
                data={exercises.map((e) => [
                  e.id,
                  e.exerciseImage
                    ? /\.(jpg|jpeg|png|webp|gif)$/i.test(e.exerciseImage)
                      ? html(
                          `<img src="${
                            e.exerciseImage.startsWith("http")
                              ? e.exerciseImage
                              : IMAGE_BASE_URL + e.exerciseImage
                          }" alt="${e.exerciseName}" 
                            style="width:80px;height:80px;object-fit:cover;border-radius:8px;" />`
                        )
                      : html(
                          `<a href="${e.exerciseImage}" target="_blank" style="color:blue;text-decoration:underline;">
                              ${e.exerciseImage}
                            </a>`
                        )
                    : "",
                  e.exerciseName,
                  e.description,
                  e.duration,
                  e.kcal,
                  (Array.from(e.subCategoryIds || []) as number[])
                    .map((id) => subCategoryMap[id] || id)
                    .join(", "),
                  equipmentMap[e.equipmentId] || "",
                  (e.modeIds || [])
                    .map((id: number) => modeMap[id] || id)
                    .join(", "),
                  html(`
                    <span class="inline-flex" style="min-width:70px;max-width:140px;">
                      <a href="/admin/exercise/exercise/edit/${e.id}" class="me-2" title="Edit">
                        <i class="mgc_edit_line text-lg"></i>
                      </a>
                      <button class="ms-2 text-red-500 hover:text-red-700" title="Delete" onclick="window.handleDeleteExercise(${e.id})">
                        <i class="mgc_delete_line text-lg"></i>
                      </button>
                    </span>
                  `),
                ])}
                columns={[
                  { name: "ID", width: "4%" },
                  { name: "Image", width: "8%" },
                  "Name",
                  "Description",
                  { name: "Duration", width: "6%" },
                  { name: "Kcal", width: "6%" },
                  { name: "Subcategories", width: "12%" },
                  { name: "Equipment", width: "10%" },
                  { name: "Mode", width: "10%" },
                  { name: "Action", width: "6%" },
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

export default Exercises;
