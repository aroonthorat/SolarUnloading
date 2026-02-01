// Master Data for Solar Unloading App
// Contains Hierarchy: Zone -> Circle -> Division -> Subdivision -> Taluka
// And Validation Rules

export const LocationHierarchy = {
    "CH. SAMBHAJINAGAR ZONE": {
        "CH. SAMBHAJINAGAR CIRCLE": {
            "CH. SAMBHAJINAGAR RURAL DIVISION": {
                "PAITHAN SUBDIVISION": ["PAITHAN"],
                "GANGAPUR SUBDIVISION": ["GANGAPUR"]
            }
        },
        "JALNA CIRCLE": {
            "JALNA DIVISION": {
                "JALNA RURAL SUBDIVISION": ["JALNA"],
                "BADNAPUR SUBDIVISION": ["BADNAPUR"]
            }
        }
    },
    "NASHIK ZONE": {
        "JALGAON CIRCLE": {
            "JALGAON DIVISION": {
                "JALGAON RURAL SUBDIVISION": ["JALGAON"],
                "DHARANGAON SUBDIVISION": ["DHARANGAON"]
            },
            "BHUSAWAL DIVISION": {
                "BHUSAWAL SUBDIVISION": ["BHUSAWAL"],
                "BODWAD SUBDIVISION": ["BODWAD"]
            }
        },
        "DHULE CIRCLE": {
            "DHULE DIVISION": {
                "DHULE RURAL SUBDIVISION": ["DHULE"]
            }
        }
    }
};

export const ValidationRules = {
    MOBILE_NO: {
        pattern: /^[6-9]\d{9}$/,
        message: "Mobile number must be 10 digits and start with 6-9"
    },
    PUMP_LOAD: {
        min: 1,
        max: 50,
        message: "Pump load must be between 1 HP and 50 HP"
    },
    DATES: {
        pattern: /^\d{4}-\d{2}-\d{2}$/,
        message: "Date must be in YYYY-MM-DD format"
    },
    REQUIRED_FIELDS: [
        'BENEFICIARY_NO', 'FULL_NAME', 'MOBILE_NO',
        'ZONE', 'CIRCLE_NAME', 'DIVISION_NAME', 'SUBDIVISION_NAME', 'TALUKA'
    ],
    READ_ONLY_FIELDS: [
        'JSR_APPR_REJ_DT',
        'JSR_REJ_REASON',
        'CREATED_AT',
        'ENTERED_BY',
        'APPLICATION_STATUS'
    ]
};

// Helper to get dropdown options
export function getOptions(parentValue, type) {
    if (!parentValue) return [];

    // Logic to traverse hierarchy based on type
    // This is a simplified helper for the UI
    return [];
}
