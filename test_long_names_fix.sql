-- Test script for long employee names overflow fix
-- This script creates test data with long employee names to verify the UI fix

-- Insert test employees with long names
INSERT INTO public.employees (id, full_name, email, phone, title, type, branch, image_url) 
VALUES 
('44444444-4444-4444-4444-444444444444', 'Alexander Hamilton Jefferson Smith', 'alexander@company.com', '444-444-4444', 'Senior Developer', 'Employee', 'IT', 'https://example.com/alexander.jpg'),
('55555555-5555-5555-5555-555555555555', 'Benjamin Franklin Roosevelt Johnson', 'benjamin@company.com', '555-555-5555', 'Product Manager', 'Employee', 'Product', 'https://example.com/benjamin.jpg'),
('66666666-6666-6666-6666-666666666666', 'Catherine Elizabeth Margaret Williams', 'catherine@company.com', '666-666-6666', 'UX Designer', 'Employee', 'Design', NULL)
ON CONFLICT (id) DO NOTHING;

-- Insert a test event
INSERT INTO public.events (id, organizer, name, about, event_time, duration, location) 
VALUES 
(888, '44444444-4444-4444-4444-444444444444', 'Project Kickoff Meeting', 'Initial project planning and team introduction', '2025-12-20 09:00:00+00', 2.0, 'Conference Room B')
ON CONFLICT (id) DO NOTHING;

-- Insert event invitations
INSERT INTO public.event_invitations (event_id, employee_id) 
VALUES 
(888, '44444444-4444-4444-4444-444444444444'),  -- Alexander invited
(888, '55555555-5555-5555-5555-555555555555'),  -- Benjamin invited
(888, '66666666-6666-6666-6666-666666666666')   -- Catherine invited
ON CONFLICT DO NOTHING;

-- Query to verify invited employees with long names
SELECT 
    e.id as employee_id,
    e.full_name,
    e.image_url
FROM public.event_invitations ei
JOIN public.employees e ON ei.employee_id = e.id
WHERE ei.event_id = 888
ORDER BY e.full_name;

-- Query to verify all employees with long names
SELECT 
    id as employee_id,
    full_name,
    image_url
FROM public.employees
WHERE id IN (
    '44444444-4444-4444-4444-444444444444',
    '55555555-5555-5555-5555-555555555555',
    '66666666-6666-6666-6666-666666666666'
)
ORDER BY full_name;