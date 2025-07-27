package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.EquipmentsRequest;
import aptech.finalproject.dto.response.exercise.EquipmentsResponse;
import aptech.finalproject.entity.auth.FileMetadata;
import aptech.finalproject.entity.exercise.EquipmentsModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.exercise.EquipmentsMapper;
import aptech.finalproject.repository.exercise.EquipmentsRepository;
import aptech.finalproject.repository.exercise.ExercisesRepository;
import aptech.finalproject.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class AdminEquipmentServiceImpl implements AdminEquipmentService {

    @Autowired
    private EquipmentsRepository equipmentsRepository;

    @Autowired
    private EquipmentsMapper equipmentsMapper;

    @Autowired
    private FileService fileService;

    @Autowired
    private ExercisesRepository exercisesRepository;

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public EquipmentsResponse createEquipment(EquipmentsRequest request) {
        EquipmentsModel equipment = equipmentsMapper.toEntity(request);

        if (request.getEquipmentImage() != null && !request.getEquipmentImage().isEmpty()) {
            FileMetadata fileMetadata = fileService.saveFileByOriginal(request.getEquipmentImage(), Optional.of("exercise"));
            equipment.setEquipmentImage(fileMetadata.getStoredName());
        }

        return equipmentsMapper.toResponse(equipmentsRepository.save(equipment));
    }

    
    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public EquipmentsResponse updateEquipment(int id, EquipmentsRequest request) {
        EquipmentsModel equipment = equipmentsRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EQUIPMENT_NOT_FOUND));

        equipmentsMapper.updateEntity(equipment, request);

        if (request.getEquipmentImage() != null && !request.getEquipmentImage().isEmpty()) {
            FileMetadata fileMetadata = fileService.saveFileByOriginal(request.getEquipmentImage(), Optional.of("exercise"));
            equipment.setEquipmentImage(fileMetadata.getStoredName());
        }

        return equipmentsMapper.toResponse(equipmentsRepository.save(equipment));
    }

    
    public EquipmentsResponse getEquipmentById(int id) {
        EquipmentsModel equipment = equipmentsRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EQUIPMENT_NOT_FOUND));

        return equipmentsMapper.toResponse(equipment);
    }

    
    public List<EquipmentsResponse> getAllEquipments() {
        return equipmentsRepository.findAll().stream()
                .map(equipmentsMapper::toResponse)
                .collect(Collectors.toList());
    }

    
    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    @Override
    public void deleteEquipment(int id) {
        EquipmentsModel equipment = equipmentsRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EQUIPMENT_NOT_FOUND));

        equipmentsRepository.deleteById(id);
    }

    
    public List<EquipmentsResponse> searchEquipmentsByName(String name) {
        return equipmentsRepository.findByEquipmentNameContainingIgnoreCase(name).stream()
                .map(equipmentsMapper::toResponse)
                .collect(Collectors.toList());
    }

    public Long countExercisesByEquipmentId(int equipmentId) {
        return exercisesRepository.countByEquipmentId(equipmentId);
    }
}

