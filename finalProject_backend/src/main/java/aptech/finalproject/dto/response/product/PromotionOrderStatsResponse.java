package aptech.finalproject.dto.response.product;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor

public class PromotionOrderStatsResponse {
    private long orderCount;
    private long orderDetailCount;
    private long paidOrderCount;
    private long unpaidOrderCount;
}
