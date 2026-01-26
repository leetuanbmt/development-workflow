import os
import json
import sys

# Đường dẫn gốc (Relative to project root)
# Mặc định là development-workflow/skills, nhưng có thể override qua tham số CLI
DEFAULT_SKILLS_DIR = "development-workflow/skills"
SKILLS_DIR = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_SKILLS_DIR

# Cấu hình Metadata chuẩn cho từng Skill
# Đây là "Knowledge Base" để định nghĩa rõ Input/Output cho từng agent
SKILL_DEFINITIONS = {
    "api_integrator": {
        "description": "Chuyên gia tích hợp API, chuyển đổi JSON/Swagger thành code Clean Architecture.",
        "inputs": [
            {"name": "json_response", "type": "json", "desc": "Mẫu JSON response từ server"},
            {"name": "swagger_spec", "type": "yaml/json", "desc": "File đặc tả API (OpenAPI)"}
        ],
        "outputs": [
            {"name": "model", "type": "dart", "desc": "Data Model (fromJson/toJson)"},
            {"name": "entity", "type": "dart", "desc": "Domain Entity"},
            {"name": "mapper", "type": "dart", "desc": "Data Mapper"}
        ]
    },
    "bug_investigator": {
        "description": "Chuyên gia điều tra lỗi, phân tích stacktrace và logs.",
        "inputs": [
            {"name": "stacktrace", "type": "text", "desc": "Error log hoặc Stacktrace"},
            {"name": "behavior", "type": "text", "desc": "Mô tả hành vi lỗi của user"}
        ],
        "outputs": [
            {"name": "root_cause", "type": "markdown", "desc": "Phân tích nguyên nhân gốc rễ"},
            {"name": "fix_plan", "type": "markdown", "desc": "Kế hoạch sửa lỗi"}
        ]
    },
    "code_reviewer": {
        "description": "Review code tự động dựa trên context nghiệp vụ và coding convention.",
        "inputs": [
            {"name": "diff", "type": "diff", "desc": "Git diff hoặc thay đổi code"},
            {"name": "context", "type": "file", "desc": "Các file liên quan"}
        ],
        "outputs": [
            {"name": "review_report", "type": "markdown", "desc": "Báo cáo review (Critical/Major/Minor)"}
        ]
    },
    "devops_engineer": {
        "description": "Quản lý CI/CD, Makefile và cấu hình build.",
        "inputs": [
            {"name": "build_config", "type": "yaml/makefile", "desc": "File cấu hình hiện tại"},
            {"name": "requirement", "type": "text", "desc": "Yêu cầu hạ tầng/deployment"}
        ],
        "outputs": [
            {"name": "script", "type": "shell", "desc": "Script tự động hóa"},
            {"name": "config", "type": "yaml", "desc": "File cấu hình đã cập nhật"}
        ]
    },
    "feature_architect": {
        "description": "Thiết kế kiến trúc tính năng, phân rã Clean Architecture.",
        "inputs": [
            {"name": "requirement", "type": "text", "desc": "Yêu cầu nghiệp vụ (User Story)"}
        ],
        "outputs": [
            {"name": "architecture_plan", "type": "markdown", "desc": "Sơ đồ layer và danh sách file cần tạo"},
            {"name": "data_flow", "type": "markdown", "desc": "Luồng dữ liệu"}
        ]
    },
    "flutter_expert": {
        "description": "Chuyên gia kỹ thuật Flutter & BLoC. Tối ưu hiệu năng (Performance), xử lý Memory Leak, Concurrency, Jank, và Review Code chuyên sâu.",
        "inputs": [
            {"name": "ui_code", "type": "dart", "desc": "Widget code hiện tại"},
            {"name": "performance_issue", "type": "text", "desc": "Vấn đề về hiệu năng, memory leak hoặc render"}
        ],
        "outputs": [
            {"name": "optimized_code", "type": "dart", "desc": "Code đã tối ưu"},
            {"name": "explanation", "type": "markdown", "desc": "Giải thích kỹ thuật"}
        ]
    },
    "localization_expert": {
        "description": "Quản lý đa ngôn ngữ và file ARB.",
        "inputs": [
            {"name": "source_text", "type": "text", "desc": "Chuỗi văn bản cần dịch"},
            {"name": "arb_file", "type": "json", "desc": "File ngôn ngữ hiện tại"}
        ],
        "outputs": [
            {"name": "arb_update", "type": "json", "desc": "Cập nhật key mới vào ARB"},
            {"name": "extension_code", "type": "dart", "desc": "Code gọi hàm l10n"}
        ]
    },
    "product_manager": {
        "description": "Chuyển đổi ý tưởng thành yêu cầu kỹ thuật chi tiết.",
        "inputs": [
            {"name": "idea", "type": "text", "desc": "Ý tưởng thô hoặc yêu cầu kinh doanh"}
        ],
        "outputs": [
            {"name": "prd", "type": "markdown", "desc": "Product Requirement Document"},
            {"name": "user_stories", "type": "markdown", "desc": "Danh sách User Stories"}
        ]
    },
    "qa_lead": {
        "description": "Lập kế hoạch kiểm thử và chiến lược chất lượng.",
        "inputs": [
            {"name": "feature_spec", "type": "markdown", "desc": "Tài liệu tính năng"}
        ],
        "outputs": [
            {"name": "test_plan", "type": "markdown", "desc": "Kế hoạch test tổng thể"},
            {"name": "test_cases", "type": "markdown", "desc": "Danh sách test case (Happy/Edge cases)"}
        ]
    },
    "security_auditor": {
        "description": "Kiểm tra bảo mật và lỗ hổng an toàn thông tin.",
        "inputs": [
            {"name": "source_code", "type": "code", "desc": "Code cần audit"},
            {"name": "config", "type": "yaml/json", "desc": "Cấu hình hệ thống"}
        ],
        "outputs": [
            {"name": "audit_report", "type": "markdown", "desc": "Báo cáo lỗ hổng và mức độ nghiêm trọng"},
            {"name": "remediation", "type": "markdown", "desc": "Hướng dẫn khắc phục"}
        ]
    },
    "tech_lead": {
        "description": "Định hướng kỹ thuật và giải quyết vấn đề phức tạp.",
        "inputs": [
            {"name": "problem", "type": "text", "desc": "Vấn đề kỹ thuật hoặc kiến trúc"},
            {"name": "constraints", "type": "text", "desc": "Ràng buộc dự án"}
        ],
        "outputs": [
            {"name": "decision", "type": "markdown", "desc": "Quyết định kỹ thuật (ADR)"},
            {"name": "guideline", "type": "markdown", "desc": "Hướng dẫn implementation"}
        ]
    },
    "technical_writer": {
        "description": "Viết tài liệu kỹ thuật, README và hướng dẫn sử dụng.",
        "inputs": [
            {"name": "codebase", "type": "code", "desc": "Source code hoặc tính năng"},
            {"name": "target_audience", "type": "text", "desc": "Đối tượng đọc (Dev/User)"}
        ],
        "outputs": [
            {"name": "documentation", "type": "markdown", "desc": "Tài liệu định dạng Markdown chuẩn"}
        ]
    },
    "test_engineer": {
        "description": "Viết Unit Test, Widget Test và Integration Test.",
        "inputs": [
            {"name": "logic_code", "type": "dart", "desc": "Business Logic hoặc Widget cần test"},
            {"name": "test_scenario", "type": "text", "desc": "Kịch bản test"}
        ],
        "outputs": [
            {"name": "test_code", "type": "dart", "desc": "File test executable"}
        ]
    },
    "ui_ux_designer": {
        "description": "Thiết kế UI/UX và đảm bảo tính thẩm mỹ.",
        "inputs": [
            {"name": "requirement", "type": "text", "desc": "Mô tả màn hình hoặc luồng người dùng"},
            {"name": "design_system", "type": "code", "desc": "Token màu sắc, typography hiện có"}
        ],
        "outputs": [
            {"name": "ui_code", "type": "dart", "desc": "Flutter Widget code"},
            {"name": "style_guide", "type": "markdown", "desc": "Hướng dẫn style"}
        ]
    }
}

DEFAULT_METADATA = {
    "description": "AI Agent Skill",
    "inputs": [{"name": "context", "type": "text", "desc": "General context"}],
    "outputs": [{"name": "response", "type": "markdown", "desc": "AI Response"}]
}

def generate_metadata():
    if not os.path.exists(SKILLS_DIR):
        print(f"❌ Directory not found: {SKILLS_DIR}")
        return

    print(f"🛠  Generating metadata.json for skills in {SKILLS_DIR}...")
    
    count = 0
    # Lấy danh sách folder trong skills
    for skill_name in os.listdir(SKILLS_DIR):
        skill_path = os.path.join(SKILLS_DIR, skill_name)
        
        if os.path.isdir(skill_path):
            # Xác định metadata content
            # Chuẩn hóa key: thử cả tên gốc và snake_case (flutter-expert -> flutter_expert)
            skill_key_snake = skill_name.replace("-", "_")
            definition = SKILL_DEFINITIONS.get(skill_name) or SKILL_DEFINITIONS.get(skill_key_snake) or DEFAULT_METADATA
            
            # Cấu trúc JSON chuẩn Google Antigravity / Agent File
            metadata_content = {
                "name": skill_name.replace("_", "-"), # Luôn đảm bảo output name là Kebab-case
                "version": "1.0.0",
                "description": definition.get("description", ""),
                "inputs": definition.get("inputs", []),
                "outputs": definition.get("outputs", []),
                "is_active": True
            }
            
            # Ghi file
            output_file = os.path.join(skill_path, "metadata.json")
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(metadata_content, f, indent=2, ensure_ascii=False)
            
            print(f"   ✅ {skill_name}: metadata.json created.")
            count += 1
            
    print(f"🎉 Completed! Generated metadata for {count} skills.")

if __name__ == "__main__":
    generate_metadata()
