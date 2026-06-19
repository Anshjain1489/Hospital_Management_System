package com.hospital.servlet;

import com.hospital.dao.AppointmentDAO;
import com.hospital.model.Appointment;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/BillServlet")
public class BillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentIdStr = request.getParameter("appointment_id");
        String totalStr         = request.getParameter("total");
        String feesStr          = request.getParameter("fees");
        String gstStr           = request.getParameter("gst");

        if (appointmentIdStr == null || totalStr == null) {
            response.sendRedirect("error.jsp?msg=Invalid+request");
            return;
        }

        try {
            int    appointmentId = Integer.parseInt(appointmentIdStr);
            double total         = Double.parseDouble(totalStr);
            double fees          = feesStr  != null ? Double.parseDouble(feesStr)  : total / 1.18;
            double gst           = gstStr   != null ? Double.parseDouble(gstStr)   : total - fees;

            Appointment appt = AppointmentDAO.getById(appointmentId);
            if (appt == null) {
                response.sendRedirect("error.jsp?msg=Appointment+not+found");
                return;
            }

            // ----- Generate real iTextPDF -----
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition",
                               "attachment; filename=\"Invoice_" + appointmentId + ".pdf\"");

            Document document = new Document(PageSize.A4, 50, 50, 50, 50);
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Fonts
            Font titleFont    = new Font(Font.FontFamily.HELVETICA, 22, Font.BOLD,   new BaseColor(13, 110, 253));
            Font headingFont  = new Font(Font.FontFamily.HELVETICA, 13, Font.BOLD,   BaseColor.DARK_GRAY);
            Font normalFont   = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL, BaseColor.DARK_GRAY);
            Font labelFont    = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD,   BaseColor.DARK_GRAY);
            Font amountFont   = new Font(Font.FontFamily.HELVETICA, 13, Font.BOLD,   new BaseColor(16, 185, 129));
            Font footerFont   = new Font(Font.FontFamily.HELVETICA,  9, Font.ITALIC, BaseColor.GRAY);

            // ---- Header ----
            Paragraph hospitalName = new Paragraph("🏥  Ansh Hospital", titleFont);
            hospitalName.setAlignment(Element.ALIGN_CENTER);
            document.add(hospitalName);

            Paragraph hospitalInfo = new Paragraph("Gursarai, India  |  anshjain1440@gmail.com  |  +91 9264974887", footerFont);
            hospitalInfo.setAlignment(Element.ALIGN_CENTER);
            hospitalInfo.setSpacingAfter(10);
            document.add(hospitalInfo);

            // Divider
            LineSeparator ls = new LineSeparator(1, 100, new BaseColor(13, 110, 253), Element.ALIGN_CENTER, -5);
            document.add(new Chunk(ls));
            document.add(Chunk.NEWLINE);

            // ---- Invoice title ----
            Paragraph invoiceTitle = new Paragraph("INVOICE", headingFont);
            invoiceTitle.setAlignment(Element.ALIGN_CENTER);
            invoiceTitle.setSpacingAfter(5);
            document.add(invoiceTitle);

            // ---- Details table ----
            PdfPTable detailsTable = new PdfPTable(2);
            detailsTable.setWidthPercentage(100);
            detailsTable.setSpacingBefore(10);
            detailsTable.setSpacingAfter(10);
            detailsTable.setWidths(new int[]{1, 1});

            addDetailCell(detailsTable, "Invoice #:",  String.valueOf(appointmentId), labelFont, normalFont);
            addDetailCell(detailsTable, "Date:",       new java.util.Date().toString(), labelFont, normalFont);
            addDetailCell(detailsTable, "Patient:",    appt.getPatientName(), labelFont, normalFont);
            addDetailCell(detailsTable, "Doctor:",     appt.getDoctorName(), labelFont, normalFont);
            addDetailCell(detailsTable, "Appt. Date:", String.valueOf(appt.getAppointmentDate()), labelFont, normalFont);
            addDetailCell(detailsTable, "Status:",
                          "Paid".equalsIgnoreCase(appt.getPaymentStatus()) ? "✓ PAID" : "⚠ UNPAID",
                          labelFont, normalFont);
            document.add(detailsTable);

            // ---- Bill breakdown table ----
            PdfPTable billTable = new PdfPTable(2);
            billTable.setWidthPercentage(100);
            billTable.setSpacingBefore(15);
            billTable.setSpacingAfter(15);
            billTable.setWidths(new int[]{3, 1});

            // Header row
            PdfPCell h1 = new PdfPCell(new Phrase("Description", labelFont));
            PdfPCell h2 = new PdfPCell(new Phrase("Amount (₹)", labelFont));
            h1.setBackgroundColor(new BaseColor(13, 110, 253)); h1.setPadding(8); h1.setBorderColor(BaseColor.WHITE);
            h2.setBackgroundColor(new BaseColor(13, 110, 253)); h2.setPadding(8); h2.setHorizontalAlignment(Element.ALIGN_RIGHT); h2.setBorderColor(BaseColor.WHITE);
            h1.setExtraParagraphSpace(2); h2.setExtraParagraphSpace(2);
            billTable.addCell(h1); billTable.addCell(h2);

            // Consultation row
            addBillRow(billTable, "Consultation Fees", String.format("%.2f", fees), normalFont);
            addBillRow(billTable, "GST (18%)",          String.format("%.2f", gst),  normalFont);

            // Total row
            PdfPCell tc1 = new PdfPCell(new Phrase("TOTAL AMOUNT", labelFont));
            PdfPCell tc2 = new PdfPCell(new Phrase("₹ " + String.format("%.2f", total), amountFont));
            tc1.setBackgroundColor(new BaseColor(240, 253, 244)); tc1.setPadding(10);
            tc2.setBackgroundColor(new BaseColor(240, 253, 244)); tc2.setPadding(10);
            tc2.setHorizontalAlignment(Element.ALIGN_RIGHT);
            billTable.addCell(tc1); billTable.addCell(tc2);

            document.add(billTable);

            // ---- Footer ----
            document.add(Chunk.NEWLINE);
            Paragraph footer = new Paragraph("Thank you for choosing Ansh Hospital. Get well soon! 💚", footerFont);
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);

            document.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=PDF+generation+failed");
        }
    }

    private void addDetailCell(PdfPTable table, String label, String value, Font lf, Font vf) {
        PdfPCell c1 = new PdfPCell(new Phrase(label, lf));
        PdfPCell c2 = new PdfPCell(new Phrase(value, vf));
        c1.setBorder(Rectangle.NO_BORDER); c1.setPadding(5);
        c2.setBorder(Rectangle.NO_BORDER); c2.setPadding(5);
        table.addCell(c1); table.addCell(c2);
    }

    private void addBillRow(PdfPTable table, String desc, String amount, Font f) {
        PdfPCell c1 = new PdfPCell(new Phrase(desc, f));
        PdfPCell c2 = new PdfPCell(new Phrase(amount, f));
        c1.setPadding(8); c2.setPadding(8);
        c2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        table.addCell(c1); table.addCell(c2);
    }
}
