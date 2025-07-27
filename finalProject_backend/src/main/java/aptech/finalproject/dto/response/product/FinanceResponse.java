package aptech.finalproject.dto.response.product;

import lombok.*;

import java.math.BigDecimal;
import java.util.List;
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class FinanceResponse {
    private int orderCount;
    private BigDecimal totalSales;
    private List<TopProduct> topSellingProducts;
    private List<TopProduct> topValueProducts;

    // Getters and setters

    public static class TopProduct {
        private Long productId;
        private String productName;
        private int quantitySold;
        private BigDecimal totalValue;

        public Long getProductId() { return productId; }
        public void setProductId(Long productId) { this.productId = productId; }

        public String getProductName() { return productName; }
        public void setProductName(String productName) { this.productName = productName; }

        public int getQuantitySold() { return quantitySold; }
        public void setQuantitySold(int quantitySold) { this.quantitySold = quantitySold; }

        public BigDecimal getTotalValue() { return totalValue; }
        public void setTotalValue(BigDecimal totalValue) { this.totalValue = totalValue; }
    }
}
