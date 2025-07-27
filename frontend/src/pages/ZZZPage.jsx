import { useEffect, useState } from "react";
import {
  getECategories,
  getEquipmentById,
  getProductCards,
  getSCategories,
} from "../services/productService";
import { apiResource } from "../services/baseApi";
import ApiImage from "../components/ui/ApiImage";

function ZZZPage() {
  const fetchData = async (id) => {
    const result = await getEquipmentById(id);
    console.log(JSON.stringify((result.data)))
  }

  useEffect(() => {
    fetchData(4);
  },[])
  return (
    <>
      <h1>Test page</h1>

    </>
  );
}

export default ZZZPage;
